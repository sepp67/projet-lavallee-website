---
title: Warum Nextcloud eine dedizierte Deployment-Rolle statt einer generischen Docker-Rolle braucht
subtitle: Erfahrungsbericht zur Bereitstellung von Nextcloud in einer mit Ansible und Docker verwalteten Staging-Umgebung.
published: 8. Juni 2026
template: article
---

Im Rahmen der Umstrukturierung meiner Infrastruktur habe ich kürzlich eine von der Produktion getrennte Staging-Umgebung eingerichtet. Das Ziel war einfach: neue Anwendungsversionen validieren, bevor sie in Produktion gehen.

Die meisten meiner Anwendungen folgen demselben Muster:

- Ein Docker-Image aus der GitHub Container Registry beziehen.
- Einen HTTP-Port freigeben.
- Den Reverse Proxy konfigurieren.
- Die korrekte Funktion der Anwendung prüfen.

Dieser Ansatz funktioniert einwandfrei für:

- Grav CMS
- Webcam Stream
- Facturier Demo
- Statische Websites

Dafür habe ich eine generische Ansible-Rolle namens erstellt:

```text
staging_docker_app
```

Diese Rolle erledigt schlicht:

1. Das Herunterladen des Images.
2. Das Erstellen des Containers.
3. Die Freigabe des Ports.
4. Das Starten des Dienstes.

Für einfache Anwendungen ist dieser Ansatz effizient, wiederverwendbar und leicht zu warten.

Nextcloud zeigte jedoch rasch die Grenzen dieser Methode.

## Die anfängliche Annahme

Zunächst nahm ich an, Nextcloud könne wie jede andere Anwendung bereitgestellt werden.

Die Konfiguration sah in etwa so aus:

```yaml
app_name: nextcloud
app_image: ghcr.io/sepp67/ansible-role-nextcloud-stack:latest
app_container_name: nextcloud-staging
app_host_port: 18080
app_container_port: 80
```

Das Deployment schien zu gelingen.

Der Container startete.

Der Proxy funktionierte.

Aber die Anwendung war nicht wirklich betriebsbereit.

## Das Problem verstehen

Anders als eine klassische Webanwendung besteht Nextcloud nicht aus einem einzigen Dienst.

Mein Deployment setzt sich zusammen aus:

```text
Nextcloud Stack
├── Nextcloud
├── PostgreSQL
├── Redis
└── Cron
```

Die Docker-Compose-Datei zeigt das deutlich:

```yaml
services:
  db:
    image: postgres

  redis:
    image: redis

  app:
    image: nextcloud

  cron:
    image: nextcloud
```

Der Hauptcontainer hängt ab von:

- PostgreSQL für die Datenspeicherung;
- Redis für Caching und Datei-Sperren;
- Cron-Aufgaben für Hintergrundverarbeitung.

Nur den Nextcloud-Container zu starten führt daher zu einem unvollständigen Deployment.

## Ein grundlegender Architekturunterschied

Meine generische Rolle beruhte auf der Annahme:

```text
Eine Anwendung = Ein Container
```

Nextcloud folgt einem anderen Modell:

```text
Eine Anwendung = Mehrere zusammenarbeitende Dienste
```

Das ist ein völlig anderes Deployment-Schema.

Der Versuch, beide Modelle in derselben Rolle zu verwalten, führt schnell zu:

- zahlreichen Sonderfällen;
- schwer nachvollziehbarer Logik;
- komplexerer Wartung;
- Verlust an Lesbarkeit.

Die generische Rolle hört dann auf, wirklich generisch zu sein.

## Die richtige Lösung

Statt die bestehende Rolle zu verkomplizieren, habe ich eine dedizierte Rolle erstellt:

```text
staging_nextcloud_stack
```

Die Verantwortlichkeiten sind nun klar getrennt.

### Generische Rolle

```text
staging_docker_app
```

Verwendet für:

- Grav
- Webcam Stream
- Facturier Demo
- Statische Websites

Verantwortlichkeiten:

- das Image herunterladen;
- den Container erstellen;
- den Port freigeben;
- den Dienst starten.

### Dedizierte Nextcloud-Rolle

```text
staging_nextcloud_stack
```

Verantwortlichkeiten:

- die persistenten Verzeichnisse erstellen;
- die Umgebungsvariablen generieren;
- die Docker-Compose-Datei generieren;
- PostgreSQL bereitstellen;
- Redis bereitstellen;
- Nextcloud bereitstellen;
- Cron bereitstellen;
- den gesamten Stack starten.

## Bestehende Komponenten wiederverwenden

Eine weitere wichtige Lektion betrifft die Wiederverwendung.

Meine Infrastruktur verfügte bereits über eine Rolle:

```text
docker_host
```

zuständig für die Installation von:

- Docker CE;
- Docker Compose Plugin;
- Buildx;
- Containerd.

Zunächst hatte ich versucht, Docker direkt aus der Nextcloud-Rolle heraus zu installieren.

Das schuf redundante Zuständigkeiten.

Die endgültige Architektur wurde:

```text
docker_host
        │
        ▼
staging_nextcloud_stack
```

Die Docker-Rolle verwaltet Docker.

Die Nextcloud-Rolle verwaltet Nextcloud.

## Endgültige Architektur

Die Staging-Umgebung stellt sich nun so dar:

```text
vm-proxy-staging
│
├── lavallee.staging.local
├── facturier.staging.local
├── grav.staging.local
├── webcam.staging.local
└── nextcloud.staging.local
```

Die Anwendungen werden auf dedizierten virtuellen Maschinen bereitgestellt.

Die Nextcloud-VM enthält:

```text
vm-nextcloud-staging
│
├── PostgreSQL
├── Redis
├── Nextcloud
└── Cron
```

Das Ganze wird automatisch mit Ansible und Docker Compose bereitgestellt.

## Fazit

Das Ziel der Automatisierung ist nicht, jedes Deployment identisch zu machen.

Das Ziel ist, jedes Deployment vorhersehbar, wartbar und nachvollziehbar zu machen.

Für einfache Anwendungen ist eine generische Rolle bestens geeignet.

Für aus mehreren Diensten bestehende Anwendungen wie Nextcloud liefert eine dedizierte Rolle eine sauberere, dauerhaftere Architektur.

Die Lektion ist einfach:

> Generische Rollen sollten generisch bleiben. Komplexe Anwendungen verdienen ihre eigene Deployment-Logik.
