# 🛠️ Comandos Úteis - Troubleshooting e Verificação

## 🐳 Docker / LocalStack

### Iniciar LocalStack
```powershell
docker-compose up -d
```

### Ver logs em tempo real
```powershell
docker logs -f localstack
```

### Ver últimas 100 linhas de logs
```powershell
docker logs --tail 100 localstack
```

### Verificar status dos containers
```powershell
docker ps
```

### Parar LocalStack
```powershell
docker-compose down
```

### Parar e remover volumes (limpar tudo)
```powershell
docker-compose down -v
```

### Reiniciar LocalStack
```powershell
docker-compose restart
```

### Verificar saúde do LocalStack
```powershell
curl http://localhost:4566/_localstack/health
```

### Entrar no container LocalStack
```powershell
docker exec -it localstack bash
```

---

## 📦 NPM / Node.js

### Instalar dependências
```powershell
cd serverless
npm install
```

### Limpar e reinstalar
```powershell
cd serverless
Remove-Item -Recurse -Force node_modules, package-lock.json
npm install
```

### Verificar versão do Node.js
```powershell
node --version
```

### Verificar versão do npm
```powershell
npm --version
```

---

## ⚡ Serverless Framework

### Deploy
```powershell
cd serverless
serverless deploy --stage local
```

### Deploy verbose (debug)
```powershell
cd serverless
serverless deploy --stage local --verbose
```

### Remover deploy
```powershell
cd serverless
serverless remove --stage local
```

### Invocar função localmente
```powershell
cd serverless
serverless invoke local -f createItem --data '{"body":"{\"title\":\"Test\",\"description\":\"Test\"}"}'
```

### Ver logs de uma função
```powershell
cd serverless
serverless logs -f createItem --stage local
```

### Ver logs em tempo real
```powershell
cd serverless
serverless logs -f createItem --stage local --tail
```

### Listar funções deployadas
```powershell
cd serverless
serverless info --stage local
```

---

## 🗄️ DynamoDB (LocalStack)

### Listar tabelas
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb list-tables
```

### Descrever tabela
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb describe-table --table-name task-manager-serverless-items-local
```

### Scan (listar todos os itens)
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local
```

### Get Item (buscar item específico)
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb get-item --table-name task-manager-serverless-items-local --key '{"id":{"S":"SEU-ID-AQUI"}}'
```

### Contagem de itens
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local --select COUNT
```

### Deletar item
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb delete-item --table-name task-manager-serverless-items-local --key '{"id":{"S":"SEU-ID-AQUI"}}'
```

### Deletar tabela
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb delete-table --table-name task-manager-serverless-items-local
```

---

## 📬 SNS (LocalStack)

### Listar tópicos
```powershell
aws --endpoint-url=http://localhost:4566 sns list-topics
```

### Listar subscrições
```powershell
aws --endpoint-url=http://localhost:4566 sns list-subscriptions
```

### Publicar mensagem manualmente
```powershell
aws --endpoint-url=http://localhost:4566 sns publish --topic-arn "arn:aws:sns:us-east-1:000000000000:items-topic-local" --message "Test message" --subject "Test"
```

### Descrever tópico
```powershell
aws --endpoint-url=http://localhost:4566 sns get-topic-attributes --topic-arn "arn:aws:sns:us-east-1:000000000000:items-topic-local"
```

---

## 🌐 API Gateway (LocalStack)

### Listar APIs
```powershell
aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis
```

### Obter API ID
```powershell
$apiId = (aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis | ConvertFrom-Json).items[0].id
echo $apiId
```

### Listar recursos (rotas)
```powershell
aws --endpoint-url=http://localhost:4566 apigateway get-resources --rest-api-id SEU-API-ID
```

### Listar deployments
```powershell
aws --endpoint-url=http://localhost:4566 apigateway get-deployments --rest-api-id SEU-API-ID
```

---

## ⚙️ Lambda (LocalStack)

### Listar funções
```powershell
aws --endpoint-url=http://localhost:4566 lambda list-functions
```

### Invocar função
```powershell
aws --endpoint-url=http://localhost:4566 lambda invoke --function-name task-manager-serverless-local-createItem --payload '{"body":"{\"title\":\"Test\",\"description\":\"Test\"}"}' response.json
```

### Ver configuração de função
```powershell
aws --endpoint-url=http://localhost:4566 lambda get-function-configuration --function-name task-manager-serverless-local-createItem
```

### Ver logs de função (se disponível)
```powershell
aws --endpoint-url=http://localhost:4566 logs tail "/aws/lambda/task-manager-serverless-local-createItem" --follow
```

---

## 🧪 Testes de API com cURL

### Criar Item
```powershell
curl -X POST http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items `
  -H "Content-Type: application/json" `
  -d '{\"title\":\"Teste\",\"description\":\"Descrição\"}'
```

### Listar Itens
```powershell
curl http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items
```

### Buscar Item por ID
```powershell
curl http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items/SEU-ITEM-ID
```

### Atualizar Item
```powershell
curl -X PUT http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items/SEU-ITEM-ID `
  -H "Content-Type: application/json" `
  -d '{\"title\":\"Atualizado\",\"completed\":true}'
```

### Deletar Item
```powershell
curl -X DELETE http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items/SEU-ITEM-ID
```

---

## 🧪 Testes de API com Invoke-RestMethod (PowerShell)

### Criar Item
```powershell
Invoke-RestMethod -Uri "http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items" `
  -Method POST `
  -Body (@{title="Teste";description="Descrição"} | ConvertTo-Json) `
  -ContentType "application/json"
```

### Listar Itens
```powershell
Invoke-RestMethod -Uri "http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items" `
  -Method GET
```

### Buscar Item por ID
```powershell
$itemId = "SEU-ITEM-ID"
Invoke-RestMethod -Uri "http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items/$itemId" `
  -Method GET
```

### Atualizar Item
```powershell
$itemId = "SEU-ITEM-ID"
Invoke-RestMethod -Uri "http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items/$itemId" `
  -Method PUT `
  -Body (@{title="Atualizado";completed=$true} | ConvertTo-Json) `
  -ContentType "application/json"
```

### Deletar Item
```powershell
$itemId = "SEU-ITEM-ID"
Invoke-RestMethod -Uri "http://localhost:4566/restapis/SEU-API-ID/local/_user_request_/items/$itemId" `
  -Method DELETE
```

---

## 🔍 Debugging

### Verificar se porta 4566 está em uso
```powershell
netstat -ano | findstr 4566
```

### Verificar variáveis de ambiente
```powershell
$env:AWS_ACCESS_KEY_ID
$env:AWS_SECRET_ACCESS_KEY
$env:AWS_DEFAULT_REGION
```

### Ver todas as variáveis de ambiente AWS
```powershell
Get-ChildItem Env: | Where-Object {$_.Name -like "AWS*"}
```

### Verificar conexão com LocalStack
```powershell
Test-NetConnection -ComputerName localhost -Port 4566
```

### Limpar cache do Docker
```powershell
docker system prune -a
```

---

## 📊 Monitoramento

### Ver uso de recursos do Docker
```powershell
docker stats localstack
```

### Ver tamanho das imagens Docker
```powershell
docker images | findstr localstack
```

### Ver volumes Docker
```powershell
docker volume ls
```

### Inspecionar container
```powershell
docker inspect localstack
```

---

## 🔄 Reset Completo

### Reset total do ambiente
```powershell
# 1. Parar e remover tudo
docker-compose down -v

# 2. Limpar node_modules
cd serverless
Remove-Item -Recurse -Force node_modules, package-lock.json

# 3. Reinstalar
npm install
cd ..

# 4. Reiniciar LocalStack
docker-compose up -d

# 5. Aguardar 10 segundos
Start-Sleep -Seconds 10

# 6. Fazer deploy
.\deploy-local.ps1

# 7. Testar
.\test-api.ps1
```

---

## 📝 Scripts de Automação

### Script para monitorar logs SNS
```powershell
# watch-sns.ps1
while ($true) {
    docker logs --tail 20 localstack | Select-String "SNS|NOTIFICACAO"
    Start-Sleep -Seconds 5
    Clear-Host
}
```

### Script para verificar saúde
```powershell
# health-check.ps1
$health = Invoke-RestMethod -Uri "http://localhost:4566/_localstack/health"
$health.services | Format-Table
```

### Script para limpar todos os itens do DynamoDB
```powershell
# clear-items.ps1
$items = aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local --query "Items[*].id.S" --output text
foreach ($id in $items -split " ") {
    aws --endpoint-url=http://localhost:4566 dynamodb delete-item --table-name task-manager-serverless-items-local --key "{\"id\":{\"S\":\"$id\"}}"
}
```

---

## 🎓 Dicas Avançadas

### 1. Ver payload completo de resposta
```powershell
Invoke-WebRequest -Uri "..." | Select-Object -ExpandProperty Content
```

### 2. Salvar resposta em arquivo
```powershell
Invoke-RestMethod -Uri "..." | ConvertTo-Json -Depth 10 | Out-File response.json
```

### 3. Medir tempo de resposta
```powershell
Measure-Command {
    Invoke-RestMethod -Uri "..."
}
```

### 4. Loop de criação de itens (stress test)
```powershell
1..10 | ForEach-Object {
    Invoke-RestMethod -Uri "..." -Method POST -Body ... -ContentType "application/json"
}
```

### 5. Exportar todos os itens para JSON
```powershell
aws --endpoint-url=http://localhost:4566 dynamodb scan --table-name task-manager-serverless-items-local | Out-File items-backup.json
```

---

## 🆘 Problemas Comuns e Soluções

### Problema: LocalStack não inicia
**Solução:**
```powershell
docker-compose down -v
docker system prune -f
docker-compose up -d
```

### Problema: API retorna 404
**Solução:**
```powershell
# Verificar se API foi deployada
aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis

# Re-deploy
cd serverless
serverless remove --stage local
serverless deploy --stage local
```

### Problema: DynamoDB não responde
**Solução:**
```powershell
# Verificar se tabela existe
aws --endpoint-url=http://localhost:4566 dynamodb list-tables

# Se não existir, fazer deploy novamente
.\deploy-local.ps1
```

### Problema: SNS não envia notificações
**Solução:**
```powershell
# Verificar tópico
aws --endpoint-url=http://localhost:4566 sns list-topics

# Verificar subscrições
aws --endpoint-url=http://localhost:4566 sns list-subscriptions

# Ver logs do subscriber
docker logs localstack | Select-String "snsSubscriber"
```

### Problema: Permissões negadas
**Solução:**
```powershell
# No LocalStack, usar credenciais fake
$env:AWS_ACCESS_KEY_ID="test"
$env:AWS_SECRET_ACCESS_KEY="test"
$env:AWS_DEFAULT_REGION="us-east-1"
```

---

**💡 Dica:** Adicione estes comandos aos seus favoritos para acesso rápido!
