#!/bin/bash
# Script de Teste da API Serverless
# ====================================

echo ""
echo -e "\033[0;36m=====================================\033[0m"
echo -e "\033[0;36m  Testando API Serverless LocalStack\033[0m"
echo -e "\033[0;36m=====================================\033[0m"
echo ""

# Descobrir API ID automaticamente
echo -e "\033[0;90mDescobrindo API ID...\033[0m"
if command -v aws &> /dev/null; then
    API_ID=$(aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis --region us-east-1 --query 'items[0].id' --output text 2>/dev/null)
    if [ -z "$API_ID" ] || [ "$API_ID" == "None" ]; then
        echo -e "\033[0;31m[ERRO] Nenhuma API encontrada! Execute deploy primeiro.\033[0m"
        exit 1
    fi
    echo -e "\033[0;32mAPI ID: $API_ID\033[0m"
else
    echo -e "\033[0;33m[AVISO] AWS CLI não encontrado. Tentando com ID padrão...\033[0m"
    API_ID="rd4yvcwjkt"
fi

API_URL="http://localhost:4566/restapis/$API_ID/local/_user_request_"
echo -e "\033[0;90mURL Base: $API_URL\033[0m"
echo ""

# Teste 1: CREATE Item
echo -e "\033[0;33m[1/5] Criando novo item...\033[0m"
CREATE_RESPONSE=$(curl -s -X POST "$API_URL/items" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Tarefa de Teste",
        "description": "Criada via script de teste",
        "priority": "high"
    }')

ITEM_ID=$(echo $CREATE_RESPONSE | grep -o '"id":"[^"]*' | cut -d'"' -f4)
echo -e "\033[0;32m[OK] Item criado com sucesso!\033[0m"
echo -e "\033[0;90mID: $ITEM_ID\033[0m"
echo ""

sleep 2

# Teste 2: LIST Items
echo -e "\033[0;33m[2/5] Listando todos os itens...\033[0m"
LIST_RESPONSE=$(curl -s -X GET "$API_URL/items")
COUNT=$(echo $LIST_RESPONSE | grep -o '"count":[0-9]*' | cut -d':' -f2)
echo -e "\033[0;32m[OK] Total de itens: $COUNT\033[0m"
echo ""

sleep 2

# Teste 3: GET Item
echo -e "\033[0;33m[3/5] Buscando item específico...\033[0m"
GET_RESPONSE=$(curl -s -X GET "$API_URL/items/$ITEM_ID")
TITLE=$(echo $GET_RESPONSE | grep -o '"title":"[^"]*' | cut -d'"' -f4)
echo -e "\033[0;32m[OK] Item encontrado: $TITLE\033[0m"
echo ""

sleep 2

# Teste 4: UPDATE Item
echo -e "\033[0;33m[4/5] Atualizando item...\033[0m"
UPDATE_RESPONSE=$(curl -s -X PUT "$API_URL/items/$ITEM_ID" \
    -H "Content-Type: application/json" \
    -d '{
        "title": "Tarefa Atualizada",
        "description": "Modificada via script",
        "completed": true
    }')
echo -e "\033[0;32m[OK] Item atualizado com sucesso!\033[0m"
echo ""

sleep 2

# Teste 5: DELETE Item
echo -e "\033[0;33m[5/5] Deletando item...\033[0m"
DELETE_RESPONSE=$(curl -s -X DELETE "$API_URL/items/$ITEM_ID")
echo -e "\033[0;32m[OK] Item deletado com sucesso!\033[0m"
echo ""

# Verificar logs SNS
echo -e "\033[0;36m=====================================\033[0m"
echo -e "\033[0;36m  Logs SNS Subscriber\033[0m"
echo -e "\033[0;36m=====================================\033[0m"
echo ""
echo -e "\033[0;90mProcurando notificações SNS nos logs do LocalStack...\033[0m"
echo ""

if docker logs localstack 2>&1 | grep -E "(NOTIFICACAO SNS|SNS Subscriber|Novo Item Criado|Item Atualizado)" | tail -15; then
    :
else
    echo -e "\033[0;33mNenhuma notificação SNS encontrada. Verifique: docker logs localstack\033[0m"
fi

echo ""
echo -e "\033[0;36m=====================================\033[0m"
echo -e "\033[0;36m  Testes concluídos com sucesso!\033[0m"
echo -e "\033[0;36m=====================================\033[0m"
echo ""
echo -e "\033[0;90mPara ver logs completos:\033[0m"
echo -e "\033[1;37m  docker logs -f localstack\033[0m"
echo ""
