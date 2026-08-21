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
      label: Name
      validate:
        required: true
    email:
      type: email
      label: Email
      validate:
        required: true
    telephone:
      type: text
      label: Phone
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
      value: Send
  process:
    - email:
        to: "{{ proprietaire_email() }}"
        reply_to: "{{ form.value('email') }}"
        subject: "[Contact lavallee.tech] Nouveau message de {{ form.value.nom }}"
        body: "{% include 'forms/contact-email.html.twig' %}"
    - redirect: /en/contact/confirmation
---

Contact form (shared definition, included from the home page via `forms('contact-form')`).
The actual recipient is never written here: `proprietaire: admin` above points
to the Grav account whose e-mail address (set outside the repository, via
`GRAV_ADMIN_EMAIL` or deployment secrets) is used as the destination.
