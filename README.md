[![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Release](https://img.shields.io/github/release/elisp-lsp/ellsp.svg?logo=github)](https://github.com/elisp-lsp/ellsp/releases/latest)
[![JCS-ELPA](https://raw.githubusercontent.com/jcs-emacs/badges/master/elpa/v/ellsp.svg)](https://jcs-emacs.github.io/jcs-elpa/#/ellsp)

# Ellsp
> Elisp Language Server

[![CI Elisp](https://github.com/elisp-lsp/ellsp/actions/workflows/test-elisp.yml/badge.svg)](https://github.com/elisp-lsp/ellsp/actions/workflows/test-elisp.yml)
[![Build Proxy](https://github.com/elisp-lsp/ellsp/actions/workflows/build-proxy.yml/badge.svg)](https://github.com/elisp-lsp/ellsp/actions/workflows/build-proxy.yml)

This software is designed to be used with editors other than Emacs. If you are
an Emacs user already, I prefer you use Emacs directly.

Here is the list of currently supported editors:

- [Emacs]() (`M-x ellsp-register`)
- [VSCode](https://marketplace.visualstudio.com/items?itemName=jcs090218.Ellsp)

## 🖼️ Gallery

### Completion

<img src="./etc/completion.png"/>

### Hover

<img src="./etc/hover.png"/>

### Signature Help

<img src="./etc/signature.png"/>

## 🔧 Prerequisites

Before installation, make sure you have all the following software installed!

- [Emacs](https://www.gnu.org/software/emacs/)
- [Eask](https://github.com/emacs-eask/cli)

## 💾 Installation

Add these lines to your `Eask`-file:

```elisp
(source 'jcs-elpa)

(development
 (depends-on "ellsp"))
```

Then install the language server:

```sh
# Install ellsp package.
$ eask install-deps --dev

# Install the proxy server.
$ eask exec install-ellsp
```

To test to see if the server installed successfully, execute the following command:

```sh
$ eask exec ellsp
```

If you see the following screen (no error), you successfully installed the language server! 🎉🥳

```sh
Updating environment variables... done v
Exporting environment variables... done v
18:45:59 [INFO ] Starting the language server...
```

*🔊 P.S. Nothing output afterward because the language server is waiting for the
language client to connect!*

## 🔬 Development

To test the language server locally:

```sh
# Add link to current package
$ eask link add ellsp ./
```

Then follow the same steps as installation:

```sh
# Install the proxy server.
$ eask exec install-ellsp

# Test the language server.
$ eask exec ellsp
```

## 🔗 References

- [Language Server Protocol Specification](https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/)
- [Elsa](https://github.com/emacs-elsa/Elsa)

## Contribute

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com)
[![Elisp styleguide](https://img.shields.io/badge/elisp-style%20guide-purple)](https://github.com/bbatsov/emacs-lisp-style-guide)
[![Donate on paypal](https://img.shields.io/badge/paypal-donate-1?logo=paypal&color=blue)](https://www.paypal.me/jcs090218)
[![Become a patron](https://img.shields.io/badge/patreon-become%20a%20patron-orange.svg?logo=patreon)](https://www.patreon.com/jcs090218)

If you would like to contribute to this project, you may either
clone or make pull requests to this repository. Or you can
clone the project and establish your branch of this tool.
Any methods are welcome!

## ⚜️ License

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

See [`LICENSE`](./LICENSE) for details.
