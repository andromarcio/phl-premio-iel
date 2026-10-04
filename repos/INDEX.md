<!-- docqui: 2.8.0 | prompt: PROMPT_REPO_MAPPING | atualizado: 2026-08-28 -->
# Repositórios do sistema
> Inventário conciliado com o código em **2026-08-28** (leitura de `pom.xml`, `package.json`, `angular.json`, `application.properties`, `Dockerfile` e dos pipelines de cada repositório). Divergências entre a documentação e o que está implementado estão em [`global/CONFORMIDADE-CODIGO.md`](../global/CONFORMIDADE-CODIGO.md).

| Repositório | URL | Responsabilidade | Stack | Responsável |
|---|---|---|---|---|
| `premio-iel` | ⚠️ a preencher | Documentação e especificações (N0–N3, data-model, protótipos, APF) | Markdown + scripts Node/Python | ⚠️ a preencher |
| `Projeto_Premio_IEL_Talentos_Backend` | ⚠️ a preencher (Azure Repos) | API REST `api-premio-iel-talentos`: regras de negócio, migrações de banco, envio de e-mail, integrações (SSO corporativo, Azure OpenAI) | Java 21 · Spring Boot 3.5.15 · JPA/Hibernate · MapStruct · Apache POI · SQL Server | ⚠️ a preencher |
| `Projeto_Premio_IEL_Talentos_Frontend` | ⚠️ a preencher (Azure Repos) | SPA: telas administrativas, do avaliador e a jornada pública de inscrição | Angular 20.3 · TypeScript 5.9 · PrimeNG 20.4 · PrimeFlex · Quill · Chart.js | ⚠️ a preencher |

> Não há repositório de *workers*: o único processamento assíncrono (envio de e-mail) roda no próprio backend, por `@Scheduled` sobre uma fila em banco.

---

## Como rodar cada repositório

| Repositório | Comando | Porta | Pré-requisitos |
|---|---|---|---|
| Backend | `./mvnw spring-boot:run` (ou executar `ApiPremioIelTalentosApplication`) | 8080 — context path `/api-premio-iel-talentos` | JDK 21 · Maven · SQL Server acessível · variáveis de ambiente abaixo · SMTP (em dev, um *mailcatcher* em `localhost:1025`) |
| Backend (testes) | `./mvnw test` | — | JUnit 5 + Mockito; cobertura por JaCoCo |
| Frontend | `npm start` (`ng serve`) | 4200 | Node · `npm ci`; aponta para `http://localhost:8080/api-premio-iel-talentos/` |
| Frontend (testes) | `npm test` | — | Karma + Jasmine em Chrome headless, com cobertura para o SonarQube |
| Frontend (build) | `npm run build:dev` · `build:hml` · `build:prod` | — | — |

> As migrações de banco **não** rodam por ferramenta (não há Flyway/Liquibase): os scripts `src/main/resources/db/migration/consolidado/V00001..V00033.sql` são aplicados manualmente e cada um registra sua execução em `TB_MIGRACAO_MANUAL` para ser idempotente.

---

## Variáveis de ambiente

### Backend (`application.properties`)

| Variável | Descrição | Exemplo / default |
|---|---|---|
| `db_server` · `db_name` · `db_username` · `db_password` | Conexão SQL Server | — |
| `URL_AUTENTICACAO` | Portal de autenticação corporativo | — |
| `URL_AUTENTICACAO_SERVICO` | API de autenticação (serviço) | — |
| `URL_CORPORATIVO_CONFIGURACOES` | API de configurações corporativas (de onde saem perfis, menus e as URLs do diretório) | — |
| `URLS_PERMITIDAS` | Origens liberadas no CORS | `http://localhost:4200/, https://premio.dev.iel.org.br, https://premioielhml.iel.org.br, https://premioiel.org.br` |
| `MAIL_SMTP_HOST` · `MAIL_SMTP_PORT` · `MAIL_SMTP_USER` · `MAIL_SMTP_PASS` · `MAIL_SMTP_AUTH` · `MAIL_SMTP_STARTTLS` | SMTP de envio | `mailcatcher` · `1025` · — · — · `false` · `false` |
| `MAIL_SMTP_FROM` | Remetente dos e-mails | `noreply@cni.org.br` |
| `PREMIO_MAIL_SYNC_ENABLED` · `PREMIO_MAIL_SYNC_DELAY` | Liga/desliga e intervalo do consumidor da fila de e-mail | `true` · `10000` (ms) |
| `AZURE_OPENAI_ENDPOINT` · `AZURE_OPENAI_API_KEY` · `AZURE_OPENAI_MODEL` · `AZURE_OPENAI_API_VERSION` · `AZURE_OPENAI_MAX_OUTPUT_TOKENS` · `AZURE_OPENAI_TIMEOUT_SECONDS` | Geração da devolutiva por IA | `https://oai-premio-iel.openai.azure.com` · — · `gpt-5.1` · `2025-04-01-preview` · `16384` · `60` |

### Frontend (`src/environments/`)

| Arquivo | `baseUrl` |
|---|---|
| `environment.development.ts` | `http://localhost:8080/api-premio-iel-talentos/` |
| `environment.hml.ts` | `https://premioielhml.iel.org.br/api-premio-iel-talentos/` |
| `environment.docker.ts` | `app_base_url` (substituído na entrada do container) |

---

## Relação entre repositórios

```
Frontend (Angular, :4200)
   │  HTTP  ─ baseUrl /api-premio-iel-talentos/
   ▼
Backend (Spring Boot, :8080)
   ├──► SQL Server                    (dados + arquivos em varbinary + fila de e-mail)
   ├──► Portal corporativo / BASI-AD  (configurações, perfis, menus, pesquisa/criação de usuário)
   ├──► SMTP                          (envio, auditado em TB_AUDITORIA_EMAIL)
   └──► Azure OpenAI                  (devolutiva consolidada por IA)
```

O **menu** da aplicação não está no código do frontend: ele é montado a partir do que o portal corporativo devolve (estrutura espelhada em `configuracoes.json`, no backend), por perfil `PIT.1`–`PIT.4`.

---

## Padrão de branches

Deduzido dos gatilhos dos pipelines de cada repositório.

| Branch | Propósito | Pipeline |
|---|---|---|
| `develop` | Desenvolvimento | backend `azure-pipelines-develop.yml` · frontend `azure-pipelines-dev.yml` |
| `homolog` | Homologação | backend `azure-pipelines-homolog.yml` · frontend `azure-pipelines-hml.yml` |
| `main` | Produção | backend `azure-pipelines-main.yml` · frontend `azure-pipelines-prd.yml` |

Cada pipeline constrói a imagem Docker e publica no Azure Container Registry; o backend expõe a porta 8080. Análise estática por SonarQube (ambos) e Snyk (backend, `.snyk`).

⚠️ Não há convenção de branch de trabalho (`feature/…`, `fix/…`) verificável a partir dos repositórios entregues — confirmar com a equipe antes de fixar a regra aqui.

---

## Convenção de commit/PR

`tipo([SIGLA]-[SFS]-[NN]): [resumo] (HU-0NN_Nome_Da_Historia)` — ex.: `feat(VAL-ANA-03): aprovar inscrição (HU-018_Analisar_Validar_Inscricao)`.

⚠️ Os repositórios de código foram entregues sem histórico git nesta sessão, então a adesão a esta convenção **não pôde ser verificada**.
