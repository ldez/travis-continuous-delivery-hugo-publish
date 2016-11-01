# Travis continuous delivery

[![Build Status](https://travis-ci.org/ldez/travis-continuous-delivery-hugo-publish.svg?branch=hugo)](https://travis-ci.org/ldez/travis-continuous-delivery-hugo-publish)

This project explains how to manipulate a Git repository within [Travis CI](https://travis-ci.org) to publish a static site build with [Hugo](https://gohugo.io/) on GitHub Page.


## SSH way (recommended)

### Generating SSH keys and encryption

See [travis-secure-key.sh](doc/travis-secure-key.sh)

[Adding a new SSH key to your GitHub account](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)

In this case you can assume to don't define a passphrase for the SSH key.

Encrypt SSH key:
- https://docs.travis-ci.com/user/encrypting-files/
- https://github.com/travis-ci/travis.rb#encrypt-file

#### GitHub token (optional)

Get a [Personal Access Token](https://github.com/settings/tokens).

Only enable `public_repo` access for public repositories, `repo` for private.
Save the token somewhere as you can only see it once.

### Use SSH key

See [publish.sh](.travis/publish.sh)

- Custom Deployment: [Git](https://docs.travis-ci.com/user/deployment/custom/#Git)
- Security information: [Security-Restrictions-when-testing-Pull-Requests](https://docs.travis-ci.com/user/pull-requests#Security-Restrictions-when-testing-Pull-Requests)


## Skip Build

### Commit message

Travis automatically skips the build if the commit contains `[ci skip]`.

- https://docs.travis-ci.com/user/customizing-the-build/#Skipping-a-build

Example:

```shell
git commit -m 'My commit message [ci skip]'
```

### Travis variables

You can skip build by defined `` variable.


## Scaffolding

Install [Hugo](https://gohugo.io/)

```shell
git init travis-continuous-delivery-hugo-publish
cd travis-continuous-delivery-hugo-publish

git checkout -b source

cd ..
hugo new site travis-continuous-delivery-hugo-publish --force

cd travis-continuous-delivery-hugo-publish

hugo new post/first-post.md
echo 'Some text.' >> content/post/first-post.md
```


## Build configuration

You must defined environement variables via Travis:
- `USER_EMAIL` : Git user email
- `USER_NAME` : Git user name
