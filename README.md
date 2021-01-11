# Pandora Toolbox

Welcome to Pandora Toolbox! If you're not in the web app already, it can be
accessed [here](https://toolbox.epimetheus.tk).

## Introduction

This is a collection of tools that analyse the Pandora Web app and provide
access to Pandora APIs.

## Features

- A dynamically generated API endpoint list (with options to export to CSV,
  JSON, and Markdown)
- A source code browser (with downloading support including helpful patches)

## Upcoming features

- An API console

## How does it work?

Pandora Toolbox uses the following methods to provide tools:

1. Analyzing source code from the Pandora Web client
2. Making Pandora API requests

All data is dynamically downloaded directly from Pandora; none of it is
hard-coded. The only connections that are made to anything other than Pandora to
use the tools are the occasional connections through
a [CORS stripper proxy](https://elements.heroku.com/buttons/gcollazo/easy-cors-proxy).

## Can I trust Pandora Toolbox with my Pandora credentials?

API requests on the web are made through the proxy linked above. It's up to you.
On other platforms, requests are made to Pandora directly - so the answer in
those cases is absolutely.