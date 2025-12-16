# 🏗️ Arquitetura Técnica Detalhada

## 📐 Visão Geral da Arquitetura

```
┌─────────────┐
│   Cliente   │
│  (cURL/API) │
└──────┬──────┘
       │
       │ HTTP Request
       ▼
┌──────────────────────────────────────────────────────────┐
│                     LocalStack                            │
│  ┌────────────────────────────────────────────────────┐  │
│  │              API Gateway                            │  │
│  │  POST /items    GET /items    PUT /items/{id}      │  │
│  │  GET /items/{id}    DELETE /items/{id}             │  │
│  └────────┬───────────────────────┬───────────────────┘  │
│           │                       │                       │
│           ▼                       ▼                       │
│  ┌─────────────────────┐  ┌─────────────────────┐       │
│  │   Lambda Functions  │  │   Lambda Functions  │       │
│  │  - createItem       │  │  - listItems        │       │
│  │  - updateItem       │  │  - getItem          │       │
│  │                     │  │  - deleteItem       │       │
│  └──────┬──────────────┘  └──────┬──────────────┘       │
│         │                        │                       │
│         │ Publish                │ Read/Write            │
│         ▼                        ▼                       │
│  ┌─────────────┐         ┌──────────────┐              │
│  │  Amazon SNS │         │  DynamoDB    │              │
│  │   Topic     │         │   Table      │              │
│  └──────┬──────┘         └──────────────┘              │
│         │                                                │
│         │ Subscribe                                      │
│         ▼                                                │
│  ┌──────────────────┐                                   │
│  │  snsSubscriber   │                                   │
│  │   Lambda         │                                   │
│  └──────────────────┘                                   │
└──────────────────────────────────────────────────────────┘
```

---

## 🔧 Componentes Principais

### 1. **API Gateway**

**Função:** Expõe endpoints REST HTTP para os clientes

**Configuração:**
- Protocolo: HTTP/REST
- CORS habilitado
- Stage: `local`
- Base URL: `http://localhost:4566/restapis/{apiId}/local/_user_request_`

**Rotas:**
| Método | Rota | Handler Lambda |
|--------|------|----------------|
| POST | /items | createItem |
| GET | /items | listItems |
| GET | /items/{id} | getItem |
| PUT | /items/{id} | updateItem |
| DELETE | /items/{id} | deleteItem |

---

### 2. **AWS Lambda Functions**

**Runtime:** Node.js 18.x

**SDK Utilizado:** AWS SDK v3 (modular)

#### 2.1 createItem.js
- **Responsabilidade:** Criar novo item no DynamoDB
- **Validação:** Campos obrigatórios (title, description)
- **Side Effect:** Publica mensagem SNS com evento CREATE
- **Resposta:** 201 Created + objeto do item criado

#### 2.2 listItems.js
- **Responsabilidade:** Listar todos os itens
- **Operação DynamoDB:** Scan
- **Resposta:** 200 OK + array de itens

#### 2.3 getItem.js
- **Responsabilidade:** Buscar item específico por ID
- **Operação DynamoDB:** GetItem
- **Resposta:** 200 OK ou 404 Not Found

#### 2.4 updateItem.js
- **Responsabilidade:** Atualizar item existente
- **Validação:** Verifica se item existe
- **Side Effect:** Publica mensagem SNS com evento UPDATE
- **Resposta:** 200 OK + objeto do item atualizado

#### 2.5 deleteItem.js
- **Responsabilidade:** Remover item do DynamoDB
- **Operação DynamoDB:** DeleteItem
- **Resposta:** 200 OK + objeto do item deletado

#### 2.6 snsSubscriber.js
- **Responsabilidade:** Processar notificações do tópico SNS
- **Trigger:** Mensagens publicadas no tópico SNS
- **Ação:** Log detalhado + processamento customizado
- **Extensível:** Pode enviar emails, webhooks, etc.

---

### 3. **Amazon DynamoDB**

**Modelo de Dados:**

| Atributo | Tipo | Chave | Obrigatório | Descrição |
|----------|------|-------|-------------|-----------|
| id | String (UUID) | HASH/PK | ✅ | Identificador único |
| title | String | - | ✅ | Título do item |
| description | String | - | ✅ | Descrição detalhada |
| priority | String | - | ❌ | low \| medium \| high |
| completed | Boolean | - | ❌ | Status de conclusão |
| createdAt | String (ISO8601) | - | ✅ | Data de criação |
| updatedAt | String (ISO8601) | - | ✅ | Data da última atualização |

**Configuração:**
- Billing Mode: PAY_PER_REQUEST (On-Demand)
- Partition Key: `id`
- Região: us-east-1

**Exemplo de Item:**
```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "title": "Implementar feature X",
  "description": "Adicionar funcionalidade Y no módulo Z",
  "priority": "high",
  "completed": false,
  "createdAt": "2025-12-15T10:30:00.000Z",
  "updatedAt": "2025-12-15T10:30:00.000Z"
}
```

---

### 4. **Amazon SNS (Simple Notification Service)**

**Tópico:** `items-topic-local`

**Protocolo de Subscrição:** Lambda

**Mensagens Publicadas:**

#### Evento CREATE
```json
{
  "action": "CREATE",
  "item": { /* objeto do item criado */ },
  "timestamp": "2025-12-15T10:30:00.000Z"
}
```

#### Evento UPDATE
```json
{
  "action": "UPDATE",
  "item": { /* objeto do item atualizado */ },
  "previousItem": { /* estado anterior do item */ },
  "timestamp": "2025-12-15T10:35:00.000Z"
}
```

**Subject da Mensagem:**
- CREATE: `Novo Item Criado: {title}`
- UPDATE: `Item Atualizado: {title}`

---

## 🔐 IAM Permissions

### Permissões das Lambda Functions

**DynamoDB:**
```yaml
- dynamodb:Query
- dynamodb:Scan
- dynamodb:GetItem
- dynamodb:PutItem
- dynamodb:UpdateItem
- dynamodb:DeleteItem
```

**SNS:**
```yaml
- sns:Publish
```

**CloudWatch Logs:**
```yaml
- logs:CreateLogGroup
- logs:CreateLogStream
- logs:PutLogEvents
```

---

## 🌐 Configuração LocalStack

### Serviços Emulados

- **Lambda:** Execução local das funções
- **DynamoDB:** Banco de dados NoSQL local
- **SNS:** Serviço de mensagens local
- **API Gateway:** Exposição de endpoints REST
- **CloudFormation:** Provisionamento de recursos
- **IAM:** Gerenciamento de permissões
- **CloudWatch Logs:** Logs das execuções

### Endpoints LocalStack

```yaml
API Gateway: http://localhost:4566
DynamoDB: http://localhost:4566
SNS: http://localhost:4566
Lambda: http://localhost:4566
CloudFormation: http://localhost:4566
```

### Credenciais Fake

```yaml
AWS_ACCESS_KEY_ID: test
AWS_SECRET_ACCESS_KEY: test
AWS_DEFAULT_REGION: us-east-1
```

---

## 📊 Fluxo de Dados

### Fluxo CREATE

```
1. Cliente → POST /items + payload JSON
2. API Gateway → Roteamento para Lambda createItem
3. Lambda createItem:
   a. Validar payload (title, description obrigatórios)
   b. Gerar UUID v4 para id
   c. Adicionar timestamps (createdAt, updatedAt)
   d. Salvar item no DynamoDB (PutCommand)
   e. Publicar mensagem SNS (PublishCommand)
4. SNS → Entrega mensagem para subscribers
5. Lambda snsSubscriber:
   a. Receber mensagem
   b. Processar e logar
   c. Executar ações customizadas
6. API Gateway → Retornar 201 + item criado ao cliente
```

### Fluxo UPDATE

```
1. Cliente → PUT /items/{id} + payload JSON
2. API Gateway → Roteamento para Lambda updateItem
3. Lambda updateItem:
   a. Buscar item existente no DynamoDB (GetCommand)
   b. Verificar se item existe (404 se não)
   c. Mesclar dados novos com existentes
   d. Atualizar timestamp (updatedAt)
   e. Salvar item atualizado no DynamoDB (PutCommand)
   f. Publicar mensagem SNS com diff (PublishCommand)
4. SNS → Entrega mensagem para subscribers
5. Lambda snsSubscriber → Processar notificação
6. API Gateway → Retornar 200 + item atualizado ao cliente
```

### Fluxo LIST

```
1. Cliente → GET /items
2. API Gateway → Roteamento para Lambda listItems
3. Lambda listItems:
   a. Executar Scan no DynamoDB
   b. Retornar todos os itens
4. API Gateway → Retornar 200 + array de itens ao cliente
```

### Fluxo GET

```
1. Cliente → GET /items/{id}
2. API Gateway → Roteamento para Lambda getItem
3. Lambda getItem:
   a. Buscar item por ID no DynamoDB (GetCommand)
   b. Verificar se item existe
4. API Gateway → Retornar 200 + item ou 404
```

### Fluxo DELETE

```
1. Cliente → DELETE /items/{id}
2. API Gateway → Roteamento para Lambda deleteItem
3. Lambda deleteItem:
   a. Buscar item existente (verificação)
   b. Deletar item do DynamoDB (DeleteCommand)
4. API Gateway → Retornar 200 + item deletado
```

---

## 🔄 Tratamento de Erros

### Erros de Validação (400 Bad Request)
- Campos obrigatórios faltando
- Tipos de dados inválidos

### Erros de Not Found (404 Not Found)
- Item não existe no banco de dados

### Erros Internos (500 Internal Server Error)
- Falha na conexão com DynamoDB
- Erro ao processar requisição
- Exception não tratada

**Estrutura de Resposta de Erro:**
```json
{
  "success": false,
  "message": "Descrição do erro",
  "error": "Detalhes técnicos (opcional)"
}
```

---

## 🧪 Estratégia de Testes

### Testes de Integração
- Verificar criação de item
- Verificar listagem de itens
- Verificar busca por ID
- Verificar atualização de item
- Verificar deleção de item

### Testes de Notificação SNS
- Verificar envio de notificação em CREATE
- Verificar envio de notificação em UPDATE
- Verificar processamento pelo subscriber

### Testes de Validação
- Rejeitar criação sem title
- Rejeitar criação sem description
- Retornar 404 para item inexistente

---

## 📈 Métricas e Observabilidade

### Logs Estruturados

Cada função Lambda registra:
- Event recebido (JSON completo)
- Operações executadas
- Resultado da operação
- Erros (com stack trace)

**Formato dos Logs:**
```
📝 CREATE Item - Event: {...}
✅ Item criado: {id}
📢 Notificação SNS enviada
```

### CloudWatch Logs (LocalStack)

Acessível via:
```bash
docker logs localstack
serverless logs -f {functionName} --stage local
```

---

## 🚀 Performance

### DynamoDB
- GetItem: ~10ms
- PutItem: ~15ms
- Scan: ~50ms (depende do número de items)

### Lambda Cold Start
- Primeira execução: ~500-1000ms
- Warm execution: ~50-100ms

### SNS
- Publish: ~10-20ms
- Delivery to Lambda: ~50-100ms

---

## 🔒 Segurança

### Boas Práticas Implementadas

1. **Validação de Input:** Todos os campos são validados antes do processamento
2. **CORS Habilitado:** Permite requisições cross-origin
3. **Least Privilege IAM:** Permissões mínimas necessárias
4. **Error Handling:** Erros não expõem informações sensíveis
5. **Idempotência:** Operações podem ser repetidas com segurança

### Melhorias Futuras

- [ ] Autenticação com AWS Cognito
- [ ] Rate Limiting no API Gateway
- [ ] Criptografia de dados em repouso
- [ ] Validação com JSON Schema
- [ ] Input sanitization contra XSS/SQL Injection

---

## 📦 Dependências

### Produção
```json
{
  "@aws-sdk/client-dynamodb": "^3.645.0",
  "@aws-sdk/client-sns": "^3.645.0",
  "@aws-sdk/lib-dynamodb": "^3.645.0",
  "uuid": "^9.0.1"
}
```

### Desenvolvimento
```json
{
  "serverless": "^3.38.0",
  "serverless-localstack": "^1.2.0",
  "serverless-offline": "^13.3.0"
}
```

---

## 🎯 Casos de Uso

### Caso de Uso 1: Task Manager
- Criar tarefas
- Listar todas as tarefas
- Marcar tarefas como concluídas
- Receber notificações de mudanças

### Caso de Uso 2: Inventory System
- Adicionar produtos
- Atualizar estoque
- Receber alertas de mudanças de estoque

### Caso de Uso 3: Event Sourcing
- Registrar eventos
- Processar eventos via SNS
- Construir audit trail

---

**Desenvolvido com ❤️ usando Serverless Framework e LocalStack**
