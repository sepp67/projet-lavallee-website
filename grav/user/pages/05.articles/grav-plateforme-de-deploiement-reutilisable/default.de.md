---
title: 'Von der Bereitstellung einer Website zur wiederverwendbaren Deployment-Plattform'
subtitle: 'Was mich ein zunächst einfacher Grav-CMS-Deploy über Persistenz, Lebenszyklen und wartbare Architekturen gelehrt hat.'
template: article
published_label: '23. August 2026'
date: '23-08-2026 12:00'
---

Viele technische Architekturen entstehen nicht am Whiteboard.

Sie beginnen mit einem konkreten Problem.

In meinem Fall war dieses Problem zunächst sehr überschaubar: Eine interne Dokumentationswebsite auf Basis von Grav CMS sollte automatisiert auf einer virtuellen Maschine bereitgestellt werden.

Docker für die Laufzeitumgebung, Ansible für das Deployment – auf den ersten Blick keine besonders komplexe Aufgabe.

Die eigentliche Architekturfrage entstand erst später:

> **Wie kann ich die Anwendung jederzeit neu deployen, ohne dabei die von den Benutzern erzeugten Daten zu gefährden?**

Aus dieser zunächst einfachen Anforderung entwickelte sich schrittweise eine wiederverwendbare Deployment-Architektur.

---

## Das erste Problem: Die Anwendung ist ersetzbar, ihre Daten sind es nicht

Grav ist ein Flat-File-CMS. Inhalte werden also nicht primär in einer klassischen Datenbank gespeichert, sondern als Dateien.

Das macht Grav für kleine Websites und Dokumentationssysteme attraktiv: Der technische Stack bleibt überschaubar und eine zusätzliche Datenbank muss nicht betrieben werden.

Für das Deployment entsteht dadurch aber eine wichtige Grenze.

Die Anwendung kann jederzeit aus einem definierten Artefakt neu aufgebaut werden.

Die Inhalte hingegen entstehen im laufenden Betrieb.

Ein Benutzer bearbeitet eine Seite.

Ein Administrator lädt ein Bild hoch.

Accounts werden angelegt.

Konfigurationen ändern sich.

Nach dem ersten produktiven Einsatz besitzt das System damit einen Zustand, der nicht mehr einfach aus dem Git-Repository rekonstruiert werden kann.

Die erste Architekturentscheidung lautete deshalb:

> **Ein Deployment darf die Anwendung ersetzen – aber nicht deren persistente Daten.**

Die relevanten Daten wurden deshalb vom Lebenszyklus des Containers getrennt.

Ein Container kann entfernt und neu erstellt werden. Die Inhalte bleiben bestehen.

Damit war das ursprüngliche Problem gelöst.

Aber nur für eine Website.

---

## Dann kam die zweite Website

Mit weiteren Projekten entstand erneut Bedarf für Grav-Websites.

An diesem Punkt hätte ich den bestehenden Aufbau einfach kopieren können.

Ein neues Docker-Compose-File.

Ein angepasster Ansible-Code.

Ein paar neue Variablen.

Deployment fertig.

Bei zwei Projekten wäre das vermutlich sogar die schnellste Lösung gewesen.

Aber damit hätte jedes neue Projekt seine eigene Variante derselben Deployment-Logik erhalten.

Spätestens beim nächsten Grav-Update hätte sich die Frage gestellt:

Welche Projekte müssen angepasst werden?

Welche Version verwendet welche PHP-Laufzeit?

Wo wurde die Deployment-Logik bereits aktualisiert?

Welche Variante unterstützt einen Rollback?

Aus einem kleinen Zeitgewinn beim zweiten Projekt wäre langfristig Wartungsaufwand entstanden.

Deshalb änderte sich die Fragestellung.

Nicht mehr:

> *Wie deploye ich diese Grav-Website?*

Sondern:

> **Wie baue ich einen Mechanismus, mit dem unterschiedliche Grav-Websites auf dieselbe Weise deployt und langfristig gewartet werden können?**

Das war der Punkt, an dem aus einer Deployment-Aufgabe eine Architekturaufgabe wurde.

---

## Nicht der Code bestimmt die Grenzen, sondern der Lebenszyklus

Bei der Analyse wurde deutlich, dass das vermeintlich eine System in Wirklichkeit aus mehreren Komponenten mit unterschiedlichen Lebenszyklen besteht:

```text
Runtime
    ≠
Website / Anwendung
    ≠
Benutzerdaten
    ≠
Deployment-Mechanismus
```

Der **Runtime** verändert sich beispielsweise, wenn Grav, PHP oder Systemabhängigkeiten aktualisiert werden.

Die **Website** verändert sich, wenn Templates, Plugins oder projektspezifische Funktionen entwickelt werden.

Die **Benutzerdaten** verändern sich unabhängig davon im laufenden Betrieb.

Und der **Deployment-Mechanismus** verändert sich wiederum aus anderen Gründen – beispielsweise wenn Health Checks, Secret Handling oder Rollback-Verfahren verbessert werden.

Diese Komponenten zusammen in einem Projekt zu verwalten, nur weil sie gemeinsam eine Website ergeben, hätte unterschiedliche Lebenszyklen künstlich miteinander gekoppelt.

Genau diese Kopplung wollte ich vermeiden.

---

## Drei Repositories, drei Verantwortlichkeiten

Daraus entstand eine Architektur mit drei klar getrennten technischen Komponenten.

### `grav-runtime` – die gemeinsame Laufzeitumgebung

Der Runtime stellt die technische Basis bereit:

* Grav,
* PHP,
* benötigte Systemkomponenten,
* gemeinsame Laufzeitkonfiguration.

Er weiß nichts über Ferienwohnungen, Dokumentationsseiten oder andere fachliche Inhalte.

Seine Aufgabe lautet ausschließlich:

> **Eine reproduzierbare Grav-Laufzeitumgebung bereitstellen.**

---

### Das Website-Repository – das konkrete Projekt

Ein Repository wie `projet-gites` enthält dagegen das, was eine bestimmte Website ausmacht:

* projektspezifische Konfiguration,
* Templates,
* Plugins,
* Design,
* initiale Inhalte.

Das Projekt muss nicht selbst lösen, wie ein Server vorbereitet oder ein Deployment durchgeführt wird.

Es beschreibt die Website.

Nicht die Deployment-Plattform.

---

### `ansible-role-grav-site` – der Deployment-Mechanismus

Der dritte Baustein automatisiert das Deployment.

Der Ansible-Role kümmert sich unter anderem darum, die erforderliche Umgebung vorzubereiten, persistente Verzeichnisse bereitzustellen, Konfiguration und Secrets einzubinden, die gewünschte Image-Version zu starten und anschließend den Zustand der Anwendung zu prüfen.

Entscheidend ist dabei:

> **Der Role soll nicht wissen, welche Website er deployt.**

Er erhält eine versionierte Anwendung und die benötigte Konfiguration.

Die Deployment-Logik bleibt dadurch unabhängig vom konkreten Projekt.

---

## Persistente Daten bilden eine vierte Grenze

Die drei Git-Repositories sind allerdings nur ein Teil der Architektur.

Daneben existiert ein vierter Bereich:

**der persistente Zustand der laufenden Instanz.**

```text
                 grav-runtime
                      │
                      ▼
              Website-Artefakt
                      │
                      ▼
            ansible-role-grav-site
                      │
                      ▼
                Grav-Instanz
                      │
             ┌────────┴────────┐
             ▼                 ▼
      Anwendung          persistente Daten
      ersetzbar          zu erhalten
```

Diese Unterscheidung hat eine wichtige Konsequenz:

Git, Container-Image und Deployment-Code können reproduziert werden.

Produktive Benutzerdaten müssen dagegen erhalten, gesichert und bei Versionswechseln gegebenenfalls migriert werden.

Damit bekommt auch der Begriff „Deployment“ eine klarere Bedeutung.

---

## Installation ist nur der Anfang

Bei einem einzelnen Serverprojekt wird häufig viel Aufmerksamkeit in die Erstinstallation investiert.

Langfristig ist sie jedoch wahrscheinlich die uninteressanteste Operation im gesamten Lebenszyklus.

Eine Website wird einmal installiert.

Danach wird sie möglicherweise jahrelang betrieben.

Die wichtigeren Fragen lauten deshalb:

**Wie wird sie aktualisiert?**

**Wie kann eine fehlerhafte Version zurückgenommen werden?**

**Wie werden persistente Daten geschützt?**

**Wie wird eine Migration auf eine neue Runtime-Version durchgeführt?**

Aus:

> **install**

wird deshalb:

> **deploy → update → rollback → migrate**

Das verändert die Perspektive.

Das Ziel ist nicht mehr, Software erfolgreich auf einen Server zu bekommen.

Das Ziel ist, **ihren gesamten technischen Lebenszyklus kontrollierbar zu machen**.

---

## Rollback ist kein Notfallverfahren

Ein gutes Beispiel dafür ist der Rollback.

Man könnte für einen Fehlerfall ein separates Recovery-Skript entwickeln und hoffen, dass es funktioniert, wenn es irgendwann benötigt wird.

Ich habe mich für einen anderen Ansatz entschieden.

Ein Rollback soll möglichst dieselbe Operation sein wie ein normales Deployment – nur mit einer anderen Version.

Wenn beispielsweise Version `1.4.0` Probleme verursacht, wird wieder die zuvor bekannte Version `1.3.2` als gewünschter Zustand definiert.

Der Deployment-Mechanismus bleibt derselbe.

Das reduziert Sonderlogik genau dort, wo man sie am wenigsten gebrauchen kann: in einer Störung.

---

## Die zweite Instanz ist der eigentliche Architekturtest

Eine Architektur als „wiederverwendbar“ zu bezeichnen, solange nur ein einziges Projekt sie verwendet, ist einfach.

Interessant wird es beim zweiten Projekt.

Genau dort zeigt sich, welche Annahmen tatsächlich generisch waren und welche unbewusst vom ersten Projekt abhingen.

Welche Namen waren fest codiert?

Welche Verzeichnisse waren projektspezifisch?

Welche Ports wurden als selbstverständlich angenommen?

Welche Konfiguration gehört zur Plattform und welche zur Anwendung?

Die zweite Instanz ist deshalb für mich nicht nur ein weiterer Nutzer der Plattform.

Sie ist ein Architekturtest.

Jede projektspezifische Annahme, die dabei sichtbar wird, hilft dabei, die Grenze zwischen Plattform und Anwendung präziser zu definieren.

---

## Was ich aus diesem Projekt mitnehme

Technisch besteht diese Lösung aus bekannten Werkzeugen.

Grav.

Docker.

Ansible.

Git.

Keines davon ist für sich genommen außergewöhnlich.

Der interessante Teil liegt für mich deshalb nicht in der Auswahl der Tools.

Er liegt in der Definition ihrer Verantwortlichkeiten.

Aus einem konkreten Problem – dem persistenten Betrieb einer internen Dokumentationswebsite – entstand zunächst ein automatisiertes Deployment.

Weitere Projekte machten anschließend sichtbar, dass Deployment allein nicht das eigentliche Problem war.

Das eigentliche Problem war **Wartbarkeit über mehrere Projekte und mehrere Jahre hinweg**.

Die wichtigste Erkenntnis daraus lautet für mich:

> **Architekturgrenzen sollten nicht nur danach definiert werden, was Komponenten tun, sondern auch danach, wie und warum sie sich verändern.**

Wenn Runtime, Anwendung, Benutzerdaten und Deployment-Mechanismus unterschiedlichen Lebenszyklen folgen, sollten diese Grenzen auch in der Architektur sichtbar sein.

Das Ergebnis ist keine spektakulär komplexe Plattform.

Im Gegenteil.

Das Ziel ist eine Plattform, die dafür sorgt, dass das nächste Projekt einfacher wird als das erste – und das zehnte nicht zehnmal mehr Deployment-Logik benötigt.

Genau darin liegt für mich der Wert einer wiederverwendbaren Architektur.
