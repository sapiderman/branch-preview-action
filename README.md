# Branch preview

Preview your latest changes. This GitHub Action deploys your branch to a Dokku instance and automatically assigns it a subdomain. This is an easy way to quickly push your latest changes and share your subdomain url for others to preview.

## Usage

Add to your .github workflow the action below.

```yml
name: Branch Preview

on: push

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Preview Branch
        uses: sapiderman/branch-preview-action@v1.0.0
        with:
          dokku_key: ${{ secrets.DOKKU_KEY }}
          host: 111.222.333.444
          port: 22 
          domain: mydomain.com
          github_token: ${{ secrets.GITHUB_TOKEN }}
          github_primary_branch: 'main'
```  

You can refer to other version, or even the main brance like so:

```yml
  uses: sapiderman/branch-preview-action@main
```

For convenience, it may be easier to set the input variables as secrets in GitHub. You can then change the value on the fly.

## Requirements

You will need a dokku instance and the ssh/private key to push your project to. You will also need a domain already pointing to your dokku. Enable virtualhost in dokku setting, so the apps can be mapped to subdomain.

## Input

You need the following requirements. Please store keys and tokens in secret.

| Requirement  | Description                                                                      |  
| :----------- | :--------------------------------------------------------------------------------|  
| host         | Dokku Host address (ip) to push your branch to                                   |  
| port         | Port if your ssh into the host is not default 22                                 |  
| domain       | Name which will be used for your domain.                                         |  
| dokku_key    | Private/SSH Key to your Dokku instance                                           |  
| github_token | Access token. `secrets.GITHUB_TOKEN`, is provided automatically by github workflow|  
| github_primary_branch | (optional) This is your primary git branch, GitHub now defaults to main. set it here |  

## Output

A `subdomain.your-domain.com` is created on your dokku instance. `subdomain` is the current branch other than the primary.

In dokku's view your `subdomain` is just an app. You can check the apps in your dokku by issueing: `dokku apps:list`  

## Troubleshooting

The best way to troubleshoot is if you are able to push from your local to the dokku. All the rights and keys should work from local as from GitHub Actions.

On your local check if this works:

`git push mydokku main:master`

Where `mydokku` is your remote dokku location that you've set using `git remote add mydokku <some address>`.

`main` is just your local git branch as source, it is the default GitHub primary branch. If your local is also master, it would look `master:master` in the command above.

If everything works on the local, it should transfer seamlessly in the GitHub Action. If not, look for the difference.

One note on environment secrets. They do not show up as *** in logs, something to note when debugging.

## Contributing

Find any issues? Feedback? Fork, fix and send the PRs this way!

## Docs

1. [changelog](./CHANGELOG.md)
2. [code of conduct](./code_of_conduct.md)
3. [LICENSE](./LICENSE)

--  
fork. clone. share.
