---
title: Warum ich Staging und Produktion auf zwei Proxmox-Knoten getrennt habe
subtitle: Wie eine selbstgehostete Plattform von einem einzigen Proxmox-Knoten zu einer zwischen Staging und Produktion getrennten Infrastruktur wechselte.
published: 2. Juni 2026
date: 2026-06-02
template: article
---

Als ich 2021 die Domain **lavallee.tech** erwarb, war mein Ziel einfach: lernen, experimentieren und ein paar Dienste für lokale Vereine hosten. Damals reichte ein einzelner, auf einem gebrauchten Dell OptiPlex installierter Proxmox-Knoten völlig aus. Ich habe dort einige YunoHost-VMs bereitgestellt, mehrere Websites gehostet und verschiedenen Vereinen Cloud- und Messaging-Dienste zur Verfügung gestellt. Fünf Jahre später hat sich die Infrastruktur stark weiterentwickelt. Was als kleines Selbsthosting-Projekt begann, wurde nach und nach zu einer Plattform, die Produktionsdienste, Entwicklungsumgebungen, Überwachungssysteme und individuelle Anwendungen beherbergt. Dieses Wachstum zwang mich schließlich, die Architektur vollständig zu überdenken.

<figure class="prose-figure">
  <img src="/articles/proxmox-staging-production/before-after-proxmox.png" alt="Architektur vorher und nachher: Wechsel von einem einzelnen Proxmox-Knoten zu einer Trennung zwischen Staging und Produktion.">
  <figcaption>Die Infrastruktur vor und nach der Trennung der Staging- und Produktionsumgebungen.</figcaption>
</figure>

## Die ursprüngliche Architektur

Die Plattform lief zunächst auf einem Dell OptiPlex 3040 mit einem Intel-i5-6500-Prozessor und 16 GB Arbeitsspeicher. Mehrere Jahre lang beherbergte diese einzige Maschine sämtliche Dienste:

- Cloud- und Messaging-Dienste für lokale Vereine
- Nextcloud- und Matrix-Deployments
- WordPress-Websites
- Überwachungssysteme
- Entwicklungsprojekte
- Produktionsanwendungen

Die Einfachheit einer Infrastruktur mit einem einzigen Knoten bot zahlreiche Vorteile. Es gab nur eine einzige zu administrierende Maschine, und die Ressourcen waren leicht zu verwalten. Solange die Anzahl der Dienste begrenzt blieb, funktionierte dieser Ansatz erstaunlich gut.

## Wenn Wachstum zum Problem wird

Die erste größere Veränderung war die Einführung eines echten Staging-/Produktions-Deployment-Zyklus. Anfangs hostete ich nur ein paar WordPress-Websites. Die Deployments waren einfach und das mit Änderungen in Produktion verbundene Risiko blieb gering. Die Lage änderte sich, als ich begann, eigene Anwendungen zu entwickeln und bereitzustellen. Eine Überwachungsinfrastruktur wurde hinzugefügt. Eine Reverse-Proxy-Architektur wurde eingerichtet. Die Website lavallee.tech wurde zu einem eigenständigen Projekt. Eine Videostreaming-Anwendung für eine IP-Kamera wurde bereitgestellt. Eine französische Anwendung für elektronische Rechnungsstellung ging in die Entwicklungsphase. Jedes neue Projekt benötigte fortan eine Produktions- und eine Staging-Umgebung. Im Laufe der Zeit erreichte die Infrastruktur nahezu zwanzig virtuelle Maschinen. Zu diesem Zeitpunkt waren die Grenzen der ursprünglichen Hardware nicht mehr zu ignorieren.

## Ein unzureichend gewordener Arbeitsspeicher

Der Dell OptiPlex 3040 ist auf 16 GB RAM begrenzt.

Heute beherbergt dieser Knoten:

- 1 AzuraCast-VM
- 1 Proxmox-Überwachungs-VM
- 4 YunoHost-VMs für lokale Vereine
- 2 WordPress-VMs
- 1 Reverse-Proxy-VM in Produktion
- 1 lavallee.tech-VM
- 1 Facturier-VM
- 1 Videostreaming-VM
- Das Äquivalent dieser Anwendungen in der Staging-Umgebung
- 2 Überwachungs-VMs für die Anwendungsplattform
- 1 Ansible-Steuerungs-VM

Das deutlichste Zeichen dafür, dass die Infrastruktur ihre Grenzen erreicht hatte, war, dass die Staging-Umgebung nicht mehr dauerhaft eingeschaltet bleiben konnte. Um die Stabilität der Produktionsdienste zu gewährleisten, musste ich sämtliche Staging-VMs abschalten. Selbst mit rund zehn abgeschalteten VMs blieb die Speicherauslastung nahe bei 80 %. Zu diesem Zeitpunkt war es nicht mehr möglich, zusätzlichen Arbeitsspeicher hinzuzufügen, da die Maschine bereits ihre maximale Kapazität erreicht hatte. Die Infrastruktur hatte die Möglichkeiten des ursprünglichen Servers schlicht überschritten.

## Warum einen zweiten Proxmox-Knoten hinzufügen?

Statt die bestehende Maschine zu ersetzen, entschied ich mich, einen zweiten Proxmox-Knoten hinzuzufügen. Der neue Server ist ein Dell OptiPlex 7010 mit einem Intel-i7-3770-Prozessor und 32 GB RAM. Ich habe bewusst erneut eine gebrauchte Workstation gewählt. Viele Homelabs setzen auf professionelle Server-Hardware, doch in meinem Fall zählt die Speicherkapazität meist mehr als die reine Prozessorleistung. Gebrauchte Dell-OptiPlex-Geräte sind günstig, zuverlässig, kompakt und leicht zu finden. Vor allem bieten sie ein hervorragendes Verhältnis von Kosten zu Kapazität für eine selbstgehostete Infrastruktur. Durch das Hinzufügen dieses zweiten Knotens stieg der verfügbare Arbeitsspeicher sofort von 16 GB auf 48 GB, bei weiterhin vertretbarem Budget.

## Staging und Produktion trennen

Das Hauptziel des neuen Knotens ist die physische Trennung von Produktions- und Staging-Workloads. Zuvor teilten sich beide Umgebungen dieselbe Hardware. Diese Organisation war zu Projektbeginn akzeptabel, wurde aber mit steigender Anzahl an Anwendungen zunehmend schwieriger zu pflegen. Die neue Architektur ist wesentlich einfacher:

<figure class="prose-figure">
  <img src="/articles/proxmox-staging-production/proxmox-two-nodes.png" alt="Proxmox-Rechenzentrum mit der Zwei-Knoten-Architektur.">
  <figcaption>Das aktuelle Proxmox-Rechenzentrum. Produktions- und Staging-Workloads sind nun auf zwei getrennte physische Server verteilt.</figcaption>
</figure>

| Knoten | CPU | RAM | Rolle |
|---|---|---|---|
| Dell OptiPlex 3040 | Intel i5-6500 | 16 GB | Produktion |
| Dell OptiPlex 7010 | Intel i7-3770 | 32 GB | Staging |

### Produktionsknoten

- Dienste für die Vereine
- Nextcloud
- Matrix
- WordPress-Websites
- Öffentlich zugängliche Anwendungen
- Reverse-Proxy-Dienste

### Staging-Knoten

- Anwendungsentwicklung
- Validierung von Deployments
- Infrastrukturtests
- Experimentelle Projekte

Diese Trennung sorgt für eine bessere Ressourcenisolation und ermöglicht es, Staging-Umgebungen dauerhaft verfügbar zu halten. Noch wichtiger: sie bringt die Organisation der Infrastruktur näher an das heran, was man in professionellen Umgebungen vorfindet.

## Die Abhängigkeit von einigen YunoHost-Instanzen verringern

YunoHost spielte eine wichtige Rolle beim Wachstum der Plattform. Es erlaubte mir, Dienste wie Nextcloud oder Matrix schnell bereitzustellen, und war ein hervorragender Einstiegspunkt ins Selbsthosting. Mit der steigenden Anzahl an Diensten traten jedoch einige Grenzen zutage. Jede YunoHost-Instanz benötigt eine dedizierte virtuelle Maschine und verbraucht deutlich mehr Speicher als ein containerisiertes Deployment. Die Überwachung mehrerer YunoHost-Instanzen wird zudem komplexer, je mehr die Infrastruktur wächst. Aus diesen Gründen habe ich diese Umstrukturierung genutzt, um einige kollaborative Dienste schrittweise zu mit Ansible verwalteten Docker-Deployments zu migrieren. Ziel ist nicht, YunoHost vollständig zu ersetzen, sondern dort ein flexibleres Modell einzusetzen, wo es sinnvoll ist.

## Eine zentralisierte Überwachung aufbauen

Ein weiteres wichtiges Motiv hinter dieser Umstrukturierung ist die Beobachtbarkeit. Mit jeder neu hinzugefügten Anwendung und virtuellen Maschine wurde die Überwachung fragmentierter. Im Laufe der Zeit wurden mehrere Monitoring-Lösungen eingesetzt, darunter eine dedizierte Plattform für Proxmox sowie separate Überwachungsumgebungen für die Anwendungen. Das langfristige Ziel ist es, die Überwachung um eine auf Prometheus, Grafana und Loki basierende Plattform zu zentralisieren. Statt jede Umgebung getrennt zu überwachen, wird die gesamte Infrastruktur von einem einzigen Punkt aus sichtbar sein. Das wird die Fehlerdiagnose vereinfachen, die Gesamtübersicht verbessern und ein besseres Verständnis des Ressourcenverbrauchs auf allen Knoten ermöglichen.

## Künftige Projekte vorbereiten

Die Infrastruktur wird zudem darauf vorbereitet, neue Anwendungen aufzunehmen. Eines der derzeit wichtigsten in Entwicklung befindlichen Projekte ist eine französische Plattform für elektronische Rechnungsstellung, die in der Lage ist, Factur-X-Rechnungen aus PDF-Dokumenten zu erzeugen. Diese Anwendung benötigt eine echte Staging-Umgebung, um neue Funktionen zu testen, bevor sie in Produktion gehen. Eine dedizierte Staging-Infrastruktur zu besitzen, beseitigt ein wesentliches Hindernis für die Entwicklung und lässt Projekte schneller voranschreiten.

## Und jetzt?

Das Ziel dieser Umstrukturierung ist nicht einfach, mehr Arbeitsspeicher hinzuzufügen. Es ist die Gelegenheit, eine Infrastruktur zu überdenken, die sich seit 2021 erheblich weiterentwickelt hat. Was als kleine selbstgehostete Umgebung für ein paar Vereine begann, ist zu einer Plattform geworden, die Produktionsdienste, Entwicklungsumgebungen, Überwachungssysteme und individuelle Anwendungen beherbergt. Durch die Trennung von Staging und Produktion, die Migration einiger Lasten zu Docker und den Aufbau einer zentralisierten Überwachungsplattform wird die Infrastruktur einfacher zu warten, leichter weiterzuentwickeln und besser auf künftige Projekte vorbereitet. Der Dell OptiPlex 3040 hat seine Aufgabe bemerkenswert gut erfüllt. Das Hinzufügen eines zweiten Proxmox-Knotens ist letztlich nur ein weiterer Schritt in der Entwicklung der Plattform.
