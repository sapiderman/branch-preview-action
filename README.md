# Branch preview github action

Enable your branch to be previewed immediately.  

## Usage

Add to your .github workflow this action

```yml
name: Deploy

on: push

jobs:
  deploy:
    name: Deploy
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v2

      - name: Preview Branch
        uses: sapiderman/branch-preview@v1
        env:
          PRIVATE_KEY: ${{ secrets.DOKKU_KEY }}  
          HOST: ${{ secrets.HOST }}  
          DOMAIN_NAME: ${{ secrets.DOMAIN }}  
```  

## Requirements

You need the
| Requirement       | Description |
| :---------------- | :----------: |  
| Host              | You need a Dokku Host to push your branch to  |
| Key               | Key for your Dokku |
| Domain            | Domain to map your subdomain to |

## Required Inputs

Add the above requirement

## Output

Your branch should be deployed to `branch_name.yourdomain.com`


