# ⚡ Início Rápido

## 🚀 3 Passos para Executar

### 1. Iniciar LocalStack
```powershell
docker-compose up -d
```

### 2. Fazer Deploy
```powershell
.\deploy-local.ps1
```

### 3. Testar API
```powershell
.\test-api.ps1
```

---

## 📋 Comandos Úteis

### Ver logs do LocalStack
```powershell
docker logs -f localstack
```

### Ver logs de uma função específica
```powershell
cd serverless
serverless logs -f createItem --stage local --tail
```

### Parar LocalStack
```powershell
docker-compose down
```

### Limpar tudo e reiniciar
```powershell
docker-compose down -v
docker-compose up -d
.\deploy-local.ps1
```

---

## 🔗 Endpoints

Após o deploy, os endpoints estarão disponíveis em:

```
http://localhost:4566/restapis/<API_ID>/local/_user_request_/items
```

**Operações disponíveis:**
- `POST /items` - Criar item
- `GET /items` - Listar items
- `GET /items/{id}` - Buscar item
- `PUT /items/{id}` - Atualizar item
- `DELETE /items/{id}` - Deletar item

---

## 📦 Payload Exemplo

```json
{
  "title": "Minha Tarefa",
  "description": "Descrição da tarefa",
  "priority": "high",
  "completed": false
}
```

---

## 🐛 Problemas Comuns

### LocalStack não inicia
```powershell
docker-compose down -v
docker-compose up -d
```

### Deploy falha
```powershell
cd serverless
npm install
cd ..
.\deploy-local.ps1
```

### API não responde
Verifique se o LocalStack está saudável:
```powershell
curl http://localhost:4566/_localstack/health
```

---

Para mais detalhes, consulte o [README.md](README.md)
