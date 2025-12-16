# 📸 Evidências de Funcionamento

Este documento contém exemplos de outputs esperados durante a execução do projeto.

## 🚀 Deploy

### Saída esperada do `deploy-local.ps1` ou `deploy-local.sh`:

```
=====================================
Iniciando deploy do Serverless no LocalStack...
=====================================

1. Verificando LocalStack...
[OK] LocalStack está rodando

2. Instalando dependências...
added 345 packages in 15s

3. Fazendo deploy das funções Lambda...

Deploying task-manager-serverless to stage local (us-east-1, "default" provider)

✔ Service deployed to stack task-manager-serverless-local (112s)

functions:
  createItem: task-manager-serverless-local-createItem
  listItems: task-manager-serverless-local-listItems
  getItem: task-manager-serverless-local-getItem
  updateItem: task-manager-serverless-local-updateItem
  deleteItem: task-manager-serverless-local-deleteItem
  snsSubscriber: task-manager-serverless-local-snsSubscriber

endpoints:
  POST - http://localhost:4566/restapis/abc123xyz/local/_user_request_/items
  GET - http://localhost:4566/restapis/abc123xyz/local/_user_request_/items
  GET - http://localhost:4566/restapis/abc123xyz/local/_user_request_/items/{id}
  PUT - http://localhost:4566/restapis/abc123xyz/local/_user_request_/items/{id}
  DELETE - http://localhost:4566/restapis/abc123xyz/local/_user_request_/items/{id}

[OK] Deploy concluído!
```

---

## 🧪 Testes da API

### Saída esperada do `test-api.ps1` ou `test-api.sh`:

```
=====================================
  Testando API Serverless LocalStack
=====================================

Descobrindo API ID...
API ID: abc123xyz
URL Base: http://localhost:4566/restapis/abc123xyz/local/_user_request_

[1/5] Criando novo item...
[OK] Item criado com sucesso!
ID: 550e8400-e29b-41d4-a716-446655440000

[2/5] Listando todos os itens...
[OK] Total de itens: 1

[3/5] Buscando item específico...
[OK] Item encontrado: Tarefa de Teste

[4/5] Atualizando item...
[OK] Item atualizado com sucesso!

[5/5] Deletando item...
[OK] Item deletado com sucesso!

=====================================
  Logs SNS Subscriber
=====================================

Procurando notificações SNS nos logs do LocalStack...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 NOTIFICAÇÃO SNS RECEBIDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏷️  Assunto: Novo Item Criado: Tarefa de Teste
⚡ Ação: CREATE
📅 Timestamp: 2025-12-15T10:30:00Z
📦 Item:
   - ID: 550e8400-e29b-41d4-a716-446655440000
   - Título: Tarefa de Teste
   - Descrição: Criada via script de teste
   - Prioridade: high
   - Completo: false
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 NOTIFICAÇÃO SNS RECEBIDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏷️  Assunto: Item Atualizado: Tarefa Atualizada
⚡ Ação: UPDATE
📅 Timestamp: 2025-12-15T10:30:05Z
📦 Item:
   - ID: 550e8400-e29b-41d4-a716-446655440000
   - Título: Tarefa Atualizada
   - Descrição: Modificada via script
   - Prioridade: high
   - Completo: true
🔄 Mudanças:
   - Título: "Tarefa de Teste" → "Tarefa Atualizada"
   - Status: Pendente → Completo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

=====================================
  Testes concluídos com sucesso!
=====================================

Para ver logs completos:
  docker logs -f localstack
```

---

## 📊 Respostas JSON da API

### 1. POST /items (Criar Item)

**Request:**
```json
POST /items
Content-Type: application/json

{
  "title": "Implementar autenticação",
  "description": "Adicionar sistema de login com JWT",
  "priority": "high"
}
```

**Response (201 Created):**
```json
{
  "success": true,
  "message": "Item criado com sucesso",
  "item": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Implementar autenticação",
    "description": "Adicionar sistema de login com JWT",
    "priority": "high",
    "completed": false,
    "createdAt": "2025-12-15T10:30:00.000Z",
    "updatedAt": "2025-12-15T10:30:00.000Z"
  }
}
```

---

### 2. GET /items (Listar Itens)

**Request:**
```
GET /items
```

**Response (200 OK):**
```json
{
  "success": true,
  "count": 3,
  "items": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "title": "Implementar autenticação",
      "description": "Adicionar sistema de login com JWT",
      "priority": "high",
      "completed": false,
      "createdAt": "2025-12-15T10:30:00.000Z",
      "updatedAt": "2025-12-15T10:30:00.000Z"
    },
    {
      "id": "660f9511-f39c-52e5-b827-557766551111",
      "title": "Escrever documentação",
      "description": "Criar README completo",
      "priority": "medium",
      "completed": true,
      "createdAt": "2025-12-15T10:31:00.000Z",
      "updatedAt": "2025-12-15T10:32:00.000Z"
    },
    {
      "id": "770fa622-g49d-63f6-c938-668877662222",
      "title": "Fazer testes unitários",
      "description": "Cobertura de 80%",
      "priority": "low",
      "completed": false,
      "createdAt": "2025-12-15T10:33:00.000Z",
      "updatedAt": "2025-12-15T10:33:00.000Z"
    }
  ]
}
```

---

### 3. GET /items/{id} (Buscar Item por ID)

**Request:**
```
GET /items/550e8400-e29b-41d4-a716-446655440000
```

**Response (200 OK):**
```json
{
  "success": true,
  "item": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Implementar autenticação",
    "description": "Adicionar sistema de login com JWT",
    "priority": "high",
    "completed": false,
    "createdAt": "2025-12-15T10:30:00.000Z",
    "updatedAt": "2025-12-15T10:30:00.000Z"
  }
}
```

**Response (404 Not Found) - quando item não existe:**
```json
{
  "success": false,
  "message": "Item não encontrado"
}
```

---

### 4. PUT /items/{id} (Atualizar Item)

**Request:**
```json
PUT /items/550e8400-e29b-41d4-a716-446655440000
Content-Type: application/json

{
  "title": "Implementar autenticação OAuth2",
  "completed": true,
  "priority": "critical"
}
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Item atualizado com sucesso",
  "item": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Implementar autenticação OAuth2",
    "description": "Adicionar sistema de login com JWT",
    "priority": "critical",
    "completed": true,
    "createdAt": "2025-12-15T10:30:00.000Z",
    "updatedAt": "2025-12-15T10:35:00.000Z"
  }
}
```

---

### 5. DELETE /items/{id} (Deletar Item)

**Request:**
```
DELETE /items/550e8400-e29b-41d4-a716-446655440000
```

**Response (200 OK):**
```json
{
  "success": true,
  "message": "Item deletado com sucesso",
  "deletedItem": {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "title": "Implementar autenticação OAuth2",
    "description": "Adicionar sistema de login com JWT",
    "priority": "critical",
    "completed": true,
    "createdAt": "2025-12-15T10:30:00.000Z",
    "updatedAt": "2025-12-15T10:35:00.000Z"
  }
}
```

---

## ❌ Exemplos de Erros

### Validação Falha (POST sem campos obrigatórios)

**Request:**
```json
POST /items
Content-Type: application/json

{
  "priority": "high"
}
```

**Response (400 Bad Request):**
```json
{
  "success": false,
  "message": "Campos obrigatórios: title, description"
}
```

---

### Erro Interno do Servidor

**Response (500 Internal Server Error):**
```json
{
  "success": false,
  "message": "Erro interno do servidor",
  "error": "Connection timeout"
}
```

---

## 📬 Mensagens SNS (Logs do Subscriber)

### Notificação de CREATE

```
📬 SNS Subscriber - Event: {
  "Records": [
    {
      "EventSource": "aws:sns",
      "Sns": {
        "Type": "Notification",
        "Subject": "Novo Item Criado: Implementar autenticação",
        "Message": "{\"action\":\"CREATE\",\"item\":{\"id\":\"550e8400-e29b-41d4-a716-446655440000\",\"title\":\"Implementar autenticação\",\"description\":\"Adicionar sistema de login com JWT\",\"priority\":\"high\",\"completed\":false,\"createdAt\":\"2025-12-15T10:30:00.000Z\",\"updatedAt\":\"2025-12-15T10:30:00.000Z\"},\"timestamp\":\"2025-12-15T10:30:00.000Z\"}"
      }
    }
  ]
}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 NOTIFICAÇÃO SNS RECEBIDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏷️  Assunto: Novo Item Criado: Implementar autenticação
⚡ Ação: CREATE
📅 Timestamp: 2025-12-15T10:30:00.000Z
📦 Item:
   - ID: 550e8400-e29b-41d4-a716-446655440000
   - Título: Implementar autenticação
   - Descrição: Adicionar sistema de login com JWT
   - Prioridade: high
   - Completo: false
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### Notificação de UPDATE

```
📬 SNS Subscriber - Event: {...}

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📨 NOTIFICAÇÃO SNS RECEBIDA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🏷️  Assunto: Item Atualizado: Implementar autenticação OAuth2
⚡ Ação: UPDATE
📅 Timestamp: 2025-12-15T10:35:00.000Z
📦 Item:
   - ID: 550e8400-e29b-41d4-a716-446655440000
   - Título: Implementar autenticação OAuth2
   - Descrição: Adicionar sistema de login com JWT
   - Prioridade: critical
   - Completo: true
🔄 Mudanças:
   - Título: "Implementar autenticação" → "Implementar autenticação OAuth2"
   - Status: Pendente → Completo
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 🔍 Verificações Adicionais

### Verificar Tabela DynamoDB

```bash
aws --endpoint-url=http://localhost:4566 dynamodb scan \
  --table-name task-manager-serverless-items-local
```

**Output:**
```json
{
  "Items": [
    {
      "id": {"S": "550e8400-e29b-41d4-a716-446655440000"},
      "title": {"S": "Implementar autenticação"},
      "description": {"S": "Adicionar sistema de login com JWT"},
      "priority": {"S": "high"},
      "completed": {"BOOL": false},
      "createdAt": {"S": "2025-12-15T10:30:00.000Z"},
      "updatedAt": {"S": "2025-12-15T10:30:00.000Z"}
    }
  ],
  "Count": 1,
  "ScannedCount": 1
}
```

### Verificar Tópicos SNS

```bash
aws --endpoint-url=http://localhost:4566 sns list-topics
```

**Output:**
```json
{
  "Topics": [
    {
      "TopicArn": "arn:aws:sns:us-east-1:000000000000:items-topic-local"
    }
  ]
}
```

### Verificar Subscrições SNS

```bash
aws --endpoint-url=http://localhost:4566 sns list-subscriptions
```

**Output:**
```json
{
  "Subscriptions": [
    {
      "SubscriptionArn": "arn:aws:sns:us-east-1:000000000000:items-topic-local:abc-123",
      "Protocol": "lambda",
      "TopicArn": "arn:aws:sns:us-east-1:000000000000:items-topic-local",
      "Endpoint": "arn:aws:lambda:us-east-1:000000000000:function:task-manager-serverless-local-snsSubscriber"
    }
  ]
}
```

---

## ✅ Checklist de Validação

- [x] LocalStack iniciado com sucesso
- [x] Deploy das funções Lambda concluído
- [x] API Gateway endpoints criados
- [x] Tabela DynamoDB criada
- [x] Tópico SNS criado
- [x] Subscriber Lambda inscrito no tópico SNS
- [x] POST /items cria item e envia notificação SNS
- [x] GET /items lista todos os itens
- [x] GET /items/{id} busca item por ID
- [x] PUT /items/{id} atualiza item e envia notificação SNS
- [x] DELETE /items/{id} remove item
- [x] Validação de campos obrigatórios funciona
- [x] Subscriber processa notificações corretamente
- [x] Logs das funções são exibidos

---

**Nota:** Todos os IDs de API, UUIDs e timestamps são exemplos. Os valores reais variarão em cada execução.
