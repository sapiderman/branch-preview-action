# Branch preview

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

## Inputs

You need the following requirements. Store keys and token in secret.

| Requirement       | Description |
| :---------------- | :-------------------------------------------: |  
| HOST              | You need a Dokku Host to push your branch to  |
| PRIVATE_KEY       | Key for your Dokku |
| DOMAIN_NAME       | Domain to map your subdomain to |


## Output

Your branch should be deployed to `branch_name.yourdomain.com`

--
fork. clone. share.
