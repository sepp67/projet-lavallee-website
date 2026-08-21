---
title: Contact
visible: false
template: contact
proprietaire: admin
form:
  name: contact-form
  fields:
    nom:
      type: text
      label: Nom
      validate:
        required: true
    email:
      type: email
      label: E-mail
      validate:
        required: true
    telephone:
      type: text
      label: Téléphone
    message:
      type: textarea
      label: Message
      validate:
        required: true
    honeypot:
      type: honeypot
  buttons:
    submit:
      type: submit
      value: Envoyer
  process:
    - email:
        to: "{{ proprietaire_email() }}"
        reply_to: "{{ form.value('email') }}"
        subject: "[Contact lavallee.tech] Nouveau message de {{ form.value.nom }}"
        body: "{% include 'forms/contact-email.html.twig' %}"
    - redirect: /fr/contact/confirmation
---

Formulaire de contact (définition partagée, inclus depuis la page d'accueil via `forms('contact-form')`).
Le destinataire réel n'est jamais écrit ici : `proprietaire: admin` ci-dessus
désigne le compte Grav dont l'adresse e-mail (définie hors du dépôt, via
`GRAV_ADMIN_EMAIL` ou les secrets de déploiement) sert de destinataire.
