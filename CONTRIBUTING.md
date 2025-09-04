# How to Contribute

This project is [licensed](./LICENSE) and accepts contributions via GitHub pull 
requests. In this document, we outline some of the conventions on development 
workflow, commit message formatting, contact points and other resources to make
it easier to get your contribution accepted.

## Getting Started

* Fork the repository.
* Read the [README.md](./README.md) for usage/test instructions.
* Play with the project, submit bugs or patches.

### Contribution Flow

>💡 This repository uses [GitHub Actions](.github/workflows) 
for automation. Changes merged into the main branch trigger the creation of 
new tag and an auto-generated [CHANGELOG.md](./CHANGELOG.md).

On the contributors' side:
1. Create a topic branch from the main brach to base your work on.
2. Make commits of logical units.
3. Push changes to a topic branch in your GitHub fork of this
repository.
4. Make sure to validate changes by running tests on a 
EWC environment.
5. Submit a pull request to this repository, including details on
the steps necessary to reproduce your tests; assign maintainers for
review/approval.

On the maintainers' side:

1. Review, validate/test internally, and provide feedback prior to approving
the pull request.
2. Upon approval, squash-merge the changes, making sure to provide a relevant
conventional commit message title (checkout 
[commit guidelines](#commit-guidelines) below).
3. Verify the CI automation updates the [CHANGELOG.md](./CHANGELOG.md),
and creates a new `git tag` on the main branch.


### Commit Guidelines

This repository enforces
[conventional commits](https://www.conventionalcommits.org/en/v1.0.0/)
to mark breaking, major and minor code changes in accordance with the
[Semantic Versioning](https://semver.org/) standard:
- Commits that land on the main branch should always be prefixed by a
specific keyword (i.e. `docs`, `style`, `feat`, `fix`, `refactor`, `ci`, 
`chore` or `test`)
- Value is communicated to the end-users by three of the prefixes:
  - `fix:` Patches a bug in your codebase.
  - `feat:` Introduces a new feature to the codebase.
  - `BREAKING CHANGE:` Introduces a breaking API change. A 
`BREAKING CHANGE` can be part of commits of any type.

## Reporting Security Vulnerabilities

Due to their public nature, GitHub and RocketChat are not appropriate places
for reporting vulnerabilities. If you suspect you have found a security 
vulnerability, please do not file a GitHub issue, but instead email 
[support@europeanweather.cloud](mailto:support@europeanweather.cloud) with the 
full details, including steps to reproduce the issue.
