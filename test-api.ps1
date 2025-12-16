# Script de Teste da API Serverless
# ====================================

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Testando API Serverless LocalStack" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Descobrir API ID automaticamente
Write-Host "Descobrindo API ID..." -ForegroundColor Gray
try {
    $apis = aws --endpoint-url=http://localhost:4566 apigateway get-rest-apis --region us-east-1 | ConvertFrom-Json
    $apiId = $apis.items[0].id
    if (-not $apiId) {
        Write-Host "[ERRO] Nenhuma API encontrada! Execute deploy primeiro." -ForegroundColor Red
        exit 1
    }
    Write-Host "API ID: $apiId" -ForegroundColor Green
} catch {
    Write-Host "[AVISO] AWS CLI nao encontrado. Tentando com ID padrao..." -ForegroundColor Yellow
    $apiId = "rd4yvcwjkt"
}

$API_URL = "http://localhost:4566/restapis/$apiId/local/_user_request_"
Write-Host "URL Base: $API_URL" -ForegroundColor Gray
Write-Host ""

# Teste 1: CREATE Item
Write-Host "[1/5] Criando novo item..." -ForegroundColor Yellow
$createResponse = Invoke-RestMethod -Uri "$API_URL/items" -Method POST -Body (@{
    title = "Tarefa de Teste"
    description = "Criada via script de teste"
} | ConvertTo-Json) -ContentType "application/json"

Write-Host "[OK] Item criado com sucesso!" -ForegroundColor Green
$itemId = $createResponse.item.id
Write-Host "ID: $itemId" -ForegroundColor Gray
Write-Host ""

Start-Sleep -Seconds 2

# Teste 2: LIST Items
Write-Host "[2/5] Listando todos os itens..." -ForegroundColor Yellow
$listResponse = Invoke-RestMethod -Uri "$API_URL/items" -Method GET
Write-Host "[OK] Total de itens: $($listResponse.items.Count)" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 2

# Teste 3: GET Item
Write-Host "[3/5] Buscando item especifico..." -ForegroundColor Yellow
$getResponse = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method GET
Write-Host "[OK] Item encontrado: $($getResponse.item.title)" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 2

# Teste 4: UPDATE Item
Write-Host "[4/5] Atualizando item..." -ForegroundColor Yellow
$updateResponse = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method PUT -Body (@{
    title = "Tarefa Atualizada"
    description = "Modificada via script"
    completed = $true
} | ConvertTo-Json) -ContentType "application/json"

Write-Host "[OK] Item atualizado com sucesso!" -ForegroundColor Green
Write-Host ""

Start-Sleep -Seconds 2

# Teste 5: DELETE Item
Write-Host "[5/5] Deletando item..." -ForegroundColor Yellow
$deleteResponse = Invoke-RestMethod -Uri "$API_URL/items/$itemId" -Method DELETE
Write-Host "[OK] Item deletado com sucesso!" -ForegroundColor Green
Write-Host ""

# Verificar logs SNS
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Logs SNS Subscriber" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Procurando notificações SNS nos logs do LocalStack..." -ForegroundColor Gray
Write-Host ""

try {
    $logs = docker logs localstack 2>&1 | Select-String -Pattern "(NOTIFICACAO SNS|SNS Subscriber|Novo Item Criado|Item Atualizado)" -Context 1,2 | Select-Object -Last 15
    if ($logs) {
        $logs | ForEach-Object { Write-Host $_.Line }
    } else {
        Write-Host "Nenhuma notificação SNS encontrada. Verifique: docker logs localstack" -ForegroundColor Yellow
    }
} catch {
    Write-Host "Erro ao buscar logs. Execute: docker logs localstack" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host "  Testes concluidos com sucesso!" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para ver logs completos:" -ForegroundColor Gray
Write-Host "  docker logs -f localstack" -ForegroundColor White
Write-Host ""
