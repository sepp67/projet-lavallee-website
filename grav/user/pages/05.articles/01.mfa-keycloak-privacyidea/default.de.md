---
title: "MFA einführen, ohne Bestehendes zu zerstören: eine architektonische Überlegung"
subtitle: Die Einführung von MFA ist der erste konkrete Schritt eines Identitätsinfrastruktur-Projekts
published_label: 22. Juni 2026
date: 2026-06-22
template: article
---

## Das Problem, das ein einfaches Plugin nicht löst

Vielleicht kennen Sie diese Situation. Ihr Authentifizierungssystem stützt sich auf ein seit Jahren bestehendes **OpenLDAP**. Es betreibt Ihre **Nextcloud**, vielleicht weitere interne Anwendungen. Alles funktioniert. Niemand möchte daran rühren.

Und dann kommt die Frage, die immer wieder auftaucht: *„Warum ist MFA noch nicht überall aktiviert?“*

Die ehrliche Antwort lautet oft: weil niemand weiß, wie man das macht, ohne alles zu zerstören.

Diebstahl von Zugangsdaten ist zum wichtigsten Einfallstor bei der Mehrheit der Sicherheitsvorfälle geworden. Ein Passwort allein, so komplex es auch sein mag, reicht nicht mehr aus, um einen Zugang zu schützen. Cyber-Versicherer wissen das, Auditoren wissen das, und immer mehr Kunden und Partner verlangen es ausdrücklich, bevor sie einen Vertrag unterschreiben. MFA (Mehrfaktor-Authentifizierung) ist damit kein Sicherheitskomfort mehr — es ist zu einer Grunderwartung geworden.

Die Frage ist nicht, **ob** man es tun sollte. Sie ist, **wie** man es tut, ohne alles infrage zu stellen.

## Drei Wege, nur einer bereitet die Zukunft vor

Betrachtet man die verfügbaren Optionen, um MFA zu einer bestehenden Infrastruktur hinzuzufügen, stößt man in der Regel auf drei Wege.

**Migration zu einer All-in-One-Identitätslösung.** Das ist das Versprechen einer modernen, integrierten Plattform, die alles verwaltet. In der Praxis ist das jedoch ein langes, teures und riskantes Projekt: das Verzeichnis muss migriert, jede Anwendung neu konfiguriert, die Teams geschult werden, und man muss ein Übergangsfenster akzeptieren, in dem alles kaputtgehen kann.

**Ein MFA-Plugin nur für eine einzelne Anwendung hinzufügen.** In unserem Fall bietet PrivacyIDEA genau ein natives Plugin für Nextcloud. Das ist schnell, kostengünstig und funktioniert. Aber es löst das Problem nur für eine einzige Anwendung. Muss morgen ein VPN, eine weitere Webanwendung oder der Zugriff auf Server geschützt werden, beginnt man mit einem anderen Werkzeug, einer anderen Logik, einem anderen Wartungsaufwand wieder bei null.

**Eine zentrale Identitätsschicht hinzufügen, ohne Bestehendes anzufassen.** Das ist auf den ersten Blick die am wenigsten intuitive Option, weil sie das Einführen neuer Komponenten erfordert. Aber es ist die einzige, die weder das Verzeichnis noch die Anwendungen anfasst und die Grundlage schafft, um später den Rest der Infrastruktur abzusichern.

Wir haben den dritten Weg gewählt. Das ist der Kern dieses Artikels: warum diese Entscheidung, wie sie technisch umgesetzt wird und was sie einmal etabliert ermöglicht.

## Die gewählte Architektur: zwei klar getrennte Rollen

<figure class="prose-figure">
  <img src="/articles/mfa-keycloak-privacyidea/add-MFA-fr.png" alt="Zwei-Faktor-Authentifizierung integrieren, ohne zu stören, was bereits funktioniert.">
</figure>

Die wichtigste Entscheidung dieses Projekts war keine Werkzeugwahl, sondern eine Entscheidung zur **Trennung der Zuständigkeiten**. Statt ein einziges Produkt zu suchen, das alles erledigt, haben wir zwei Komponenten zwischen Verzeichnis und Anwendungen eingeführt, jede mit einer klaren Rolle.

### Keycloak als einziger Durchgangspunkt

Die erste Komponente ist **Keycloak**, eingesetzt als *Identity Provider* (Identitätsanbieter). Seine Rolle: der einzige Punkt zu werden, über den sämtliche Authentifizierungen der Organisation laufen. Keycloak verbindet sich mit dem bestehenden OpenLDAP-Verzeichnis — ohne es zu verändern — und nimmt nun die Anmeldeanfragen entgegen, anstelle jeder einzelnen Anwendung.

Konkret prüft Nextcloud nicht mehr selbst ein Passwort im Verzeichnis. Es delegiert diese Prüfung an Keycloak. Für den Nutzer ändert sich äußerlich nichts. Für die Organisation ändert sich strukturell alles: es gibt nun eine einzige Stelle, an der über Authentifizierungsregeln entschieden wird, statt einer Regel pro Anwendung.

### PrivacyIDEA, Spezialist für den zweiten Faktor

Die zweite Komponente ist **PrivacyIDEA**. Man sollte genau sein, was es ist, denn hier entsteht oft Verwirrung: PrivacyIDEA ist **kein** Identitätsanbieter. Es ist ein **Token-Server**. Seine Rolle beschränkt sich auf eine Sache, die es aber sehr gut erledigt: einen zweiten Faktor (OTP-Token, mobile App usw.) für jeden Verzeichnisnutzer zu registrieren und den bei der Anmeldung eingegebenen Wert zu prüfen.

Keycloak selbst bietet nativ einen Mechanismus zur Token-Registrierung. Warum nicht dabei bleiben? Weil dessen Optionen auf einfache Szenarien beschränkt bleiben. PrivacyIDEA hingegen ist darauf ausgelegt, **Authentifizierungs-Workflows** zu verwalten — und genau das rechtfertigt seine Anwesenheit in der Architektur statt einer alleinigen Abhängigkeit von Keycloak.

## Authentifizierung als Prozess, nicht als Häkchen

Authentifizierung ist kein binärer Vorgang. Es ist eine Abfolge von Prüfungen, die sehr einfach bleiben oder je nach Bedarf der Organisation sehr umfangreich werden kann. Das wird oft übersehen, wenn man MFA wie einen einfachen Schalter behandelt — dabei ist es ein zu gestaltender Workflow.

Im einfachsten von uns umgesetzten Szenario:

- Keycloak prüft das Passwort direkt beim OpenLDAP-Verzeichnis.
- PrivacyIDEA prüft parallel nur den Wert des Einmalcodes (OTP).

Jede Komponente macht eine Sache, und macht sie gut. Aber die Architektur erlaubt mehr: Es ist möglich, das Passwort auch an PrivacyIDEA weiterzugeben, das es dann als Auslöser für ausgefeiltere Szenarien nutzen kann — je nach Nutzerprofil einen anderen Faktor verlangen, die Richtlinie je nach Anmeldekontext anpassen oder mehrere Prüfungen verketten. Diese Flexibilität bietet der native Mechanismus von Keycloak allein zu diesem Zeitpunkt nicht.

Ein bei MFA-Einführungen oft übersehener Punkt: Was passiert bei einem Nutzer, der sich zum ersten Mal anmeldet, ohne bereits einen zweiten Faktor registriert zu haben? Das ist ein Fall, den die Architektur explizit behandeln muss — der Workflow muss das Fehlen eines Tokens erkennen und einen Registrierungsablauf auslösen können, statt den Nutzer schlicht zu blockieren. Das ist ein Detail, aber oft genau jenes, das darüber entscheidet, ob eine MFA-Einführung reibungslos verläuft oder eine Flut von Support-Tickets erzeugt.

Zu diesem Zeitpunkt musste keine der bestehenden Anwendungen grundlegend neu konfiguriert werden. OpenLDAP bleibt das unveränderte Referenzverzeichnis. Nextcloud funktioniert weiterhin normal, einfach neu verbunden mit Keycloak statt direkt mit dem Verzeichnis.

## Warum diese scheinbar „schwerere“ Architektur tatsächlich die richtige Wahl ist

Hier zeigt sich der volle Sinn der architektonischen Überlegung. Ein für Nextcloud spezifisches MFA-Plugin hätte das unmittelbare Problem schneller gelöst. Aber es hätte auch die Tür zu allem verschlossen, was natürlich folgt, sobald MFA etabliert ist: andere Anwendungen, andere Zugriffsarten mit derselben Konsistenz abzusichern.

Indem wir Keycloak in die Mitte gestellt haben, haben wir nicht nur Nextcloud geschützt. Wir haben einen einzigen Durchgangspunkt geschaffen, der die Sicherheitsanforderungen der kommenden Jahre aufnehmen kann, ohne neu aufgebaut werden zu müssen. Das ist der Unterschied zwischen einer punktuellen Korrektur und einer Investition in die Infrastruktur — und genau die Art von Abwägung, die ein Architekt explizit machen sollte, bevor der erste Baustein gesetzt wird, statt sie erst zu entdecken, wenn ein zweiter Bedarf auftritt.

### OpenID Connect: die Tür zu Webanwendungen öffnen

Sobald Keycloak etabliert ist, eröffnet sich eine neue Möglichkeit: jede mit **OpenID Connect** (OIDC) kompatible Webanwendung anzubinden.

OpenID Connect ist ein offenes Protokoll — im gleichen Sinne, wie HTTP es für das Web ist —, das definiert, wie eine Anwendung die Authentifizierung ihrer Nutzer an einen externen Identitätsanbieter delegiert. Die Funktionsweise beruht auf drei Elementen:

- Der **OpenID Provider (OP)**: das ist Keycloak. Er authentifiziert den Nutzer und stellt ein Token aus.
- Das **ID Token**: ein Token im JWT-Format, das bestätigt, dass der Nutzer authentifiziert wurde, und einige seiner Informationen transportiert.
- Die **Relying Party (RP)**: die Client-Anwendung — jene, die der Nutzer tatsächlich nutzen möchte. Sie vertraut dem von Keycloak ausgestellten Token, statt die Authentifizierung selbst zu verwalten.

Was dieses Protokoll für eine Organisation wertvoll macht, ist das, was es nicht verändert. Eine über OpenID Connect angebundene Anwendung behält ihre eigene Konfiguration, ihre eigenen Benutzergruppen, ihre eigenen internen Rechte. Nur die Authentifizierung wird delegiert. Wo die Integration eines neuen Authentifizierungssystems üblicherweise Wochen spezifischer Entwicklung erfordert, lässt sich eine OIDC-kompatible Anwendung in der Regel innerhalb weniger Stunden an Keycloak anbinden.

### RADIUS: dieselbe Logik für VPNs und Server

Web-Authentifizierung ist nicht das einzige abzusichernde Terrain. VPN-Zugänge und Verbindungen zu virtuellen Maschinen beruhen in der Regel auf einem anderen Protokoll: **RADIUS**.

Dieselbe für Web-MFA aufgebaute Identitätsarchitektur lässt sich natürlich auf diese Anwendungsfälle ausweiten. Das Prinzip bleibt identisch: ein zentraler Authentifizierungspunkt, der ein Passwort und einen zweiten Faktor prüfen kann, unabhängig vom Kanal — eine Webseite, eine VPN-Verbindung oder der Zugriff auf einen Server.

Genau hier zeigt sich der volle Wert der anfänglichen Investition. Die Organisation setzt nicht ein MFA-Werkzeug für Nextcloud, ein weiteres für das VPN und ein drittes für die Server ein. Sie setzt eine einzige Authentifizierungsrichtlinie um, konsistent angewendet, überall dort, wo sie benötigt wird.

## Was man sich merken sollte

MFA ist nie ein isoliertes Projekt. Es ist immer der erste Baustein eines Identitätsinfrastruktur-Projekts.

Der Unterschied ist bei der Bewertung entscheidend: Ein MFA-Projekt endet, wenn der zweite Faktor funktioniert. Ein Identitätsinfrastruktur-Projekt erzeugt weiterhin Wert bei jeder neu angebundenen Anwendung, bei jedem neu abgesicherten Zugang, ohne dass man bei null neu anfangen müsste.

Genau diese Art von Architektur weiß ich zu konzipieren und umzusetzen: von einem bestehenden System ausgehen, ohne es zu zerstören, und darauf eine Identitätsschicht aufzubauen, die die Sicherheitsanforderungen der kommenden Jahre aufnehmen kann.

Wenn sich Ihr Unternehmen in dieser Situation befindet (ein OpenLDAP, eine Nextcloud oder ein anderes bestehendes System) und ein MFA-Bedarf ansteht, der sich als erster einer langen Reihe von Sicherheitsanforderungen abzeichnet, lassen Sie uns darüber sprechen. Genau das ist die Art von Projekt, die ich begleite.
