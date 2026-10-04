<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-ANA-01
feature_set: VAL-ANA
dominio: VAL
entidade: Inscrição
data_model_ref: data-models/inscricao.md#inscricao
endpoints: []
error_codes: []
depende_de: []
origem:
  tipo: issue
  chave: HU-018_Analisar_Validar_Inscricao
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
contagem:
  pendente: true
  revisada_em: ""
  revisada_ate: ""
---

# Detalhar Inscrição
> **Nível 3** - Feature Set: Análise e Decisão — Major Feature Set: Validação - `VAL-ANA-01`

## Descrição
Permite ao validador detalhar uma inscrição em modo leitura, reunindo os dados do formulário, o questionário, os documentos, a equipe, os termos e o histórico de validação para embasar a decisão.

Na Fila de Validação, o validador aciona o ícone de visualização da inscrição, que abre o detalhe numa nova aba; ali expande as seções — como dados do formulário, documentos e equipe —, pré-visualiza ou baixa os documentos e acompanha o histórico em linha do tempo, com as ações de decisão que a situação da inscrição permite.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-018_Analisar_Validar_Inscricao`](../../../hus/HU-018_Analisar_Validar_Inscricao.docx) | Criação | — detalhe com os indicadores de progresso, as seções retráteis (formulário, questionário, documentos com pré-visualização e download, equipe em cards e termos), o histórico em linha do tempo e o banner de veredito com o parecer e a data da decisão |
| [`PDTIC25093-68`](../../../analise-impacto/AIM-PDTIC25093-68.md) | Alteração | — download de cada documento por endereço individual, conferido a cada acesso a quem tem direito à inscrição |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/validacao-inscricao/inscricoes/:inscricaoId/detalhe` (Detalhe da Inscrição)

**Fidelidade ao protótipo**: referência — `prototypes/validacao/analise-decisao/flow.html`

---

</div>

## Regras de negócio

1. O detalhe da inscrição é somente leitura: a análise não altera os dados informados pelo participante.
2. As ações de decisão dependem da situação: iniciar a validação exige a situação Finalizada; aprovar, rejeitar e solicitar ajuste exigem a situação Em Validação.
3. Uma inscrição já Validada ou Rejeitada tem o parecer e a data da decisão associados ao seu veredito.
4. O histórico de validação registra cada transição de situação com data, responsável e parecer.
5. O detalhe de uma inscrição só é acessível ao validador vinculado à unidade federativa da inscrição.
6. Cada documento anexado à inscrição tem um identificador público próprio, distinto do identificador interno do documento e da inscrição, que endereça individualmente o download daquele documento.
7. O identificador público é único no sistema e acompanha o documento enquanto ele estiver anexado à inscrição; documentos diferentes nunca compartilham o mesmo identificador.
8. O download de um documento pelo seu identificador público alcança apenas quem tem direito à inscrição — o administrador com alcance sobre a unidade federativa da inscrição, o avaliador alocado a ela e o participante autor —, e esse direito é conferido a cada acesso, independentemente de quem detenha o endereço do documento.

> O mesmo endereçamento individual por documento habilita o download de anexo pelo avaliador alocado, especificado em `AVL-AVA-03` Avaliar Inscrição.

---

## Cenários

```gherkin
Feature: Detalhar Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Abrir o detalhe completo da inscrição
    Given que selecionei uma inscrição na Fila de Validação
    When abro o detalhe da inscrição
    Then o sistema exibe os dados do formulário, o questionário, os documentos, a equipe, os termos e o histórico de validação

  Scenario: Fazer o download de um documento anexado
    Given que estou no detalhe de uma inscrição a que tenho direito e que possui documentos
    When aciono o download de um documento
    Then o sistema confere o meu direito à inscrição e disponibiliza o arquivo pelo endereço individual daquele documento

  Scenario: Endereço individual por documento anexado
    Given que a inscrição possui mais de um documento anexado
    When consulto a relação de documentos
    Then cada documento é endereçado por um link de download próprio

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Ações disponíveis para inscrição finalizada
    Given que a inscrição está na situação Finalizada
    When abro o detalhe da inscrição
    Then o início da validação fica disponível e as ações de aprovar e rejeitar não

  Scenario: Veredito de inscrição já decidida
    Given que a inscrição está na situação Validada
    When abro o detalhe da inscrição
    Then o sistema apresenta o parecer e a data da decisão

  # ── Restrições de acesso ───────────────────────────────────────

  Scenario: Inscrição de outra unidade federativa
    Given que a inscrição pertence a uma unidade a que não estou vinculado
    When tento abrir o detalhe da inscrição
    Then o sistema bloqueia e exibe "Você não tem permissão para esta ação."

  Scenario: Download de documento por quem não tem direito à inscrição
    Given que tenho o link de download de um documento de uma inscrição a que não tenho direito
    When aciono esse link
    Then o sistema bloqueia o download e exibe "Você não tem permissão para esta ação."
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Protocolo | Inscrição | exibido do cadastro | somente leitura | texto | — | — |
| Identificação do participante | Inscrição | exibido do cadastro | somente leitura | texto | — | — |
| Situação | Inscrição | exibido do cadastro | somente leitura | lista (situações de validação) | — | — |
| Dados do formulário | Resposta de Formulário | exibido do cadastro | somente leitura | grupo de respostas do formulário dinâmico | — | — |
| Questionário | Resposta de Questão | exibido do cadastro | somente leitura | grupo de respostas do questionário | — | — |
| Documentos | Documento da Inscrição | exibido do cadastro | somente leitura | lista de anexos, cada um com endereço individual de download | — | download restrito a quem tem direito à inscrição |
| Equipe | Membro de Equipe da Inscrição | exibido do cadastro | somente leitura | cards com nome, CPF, e-mail e telefone; campos canônicos → ver FIELD-DICTIONARY: `CPF` · `E-mail` · `Telefone` | — | — |
| Termos | Aceite de Termo do Participante | exibido do cadastro | somente leitura | lista de termos aceitos | — | — |
| Histórico de validação | Histórico da Inscrição | exibido do cadastro | somente leitura | linha do tempo de transições de situação | — | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Identificador público do documento | Identificador próprio do documento, único no sistema | Quando o documento é anexado à inscrição |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Validação de Inscrição | lê | O banner de veredito da inscrição já Validada ou Rejeitada traz o parecer e a data da decisão (regra 3) |
| Premiação | lê | O cabeçalho do detalhe identifica a premiação da inscrição (ALR do baseline) |
| Categoria | lê | O cabeçalho do detalhe identifica a categoria da inscrição (ALR do baseline) |
| Modalidade | lê | O cabeçalho do detalhe identifica a modalidade da inscrição (ALR do baseline) |
| Tipo de Participante | lê | O cabeçalho identifica o tipo de participante, e a seção do questionário traz o título e a obrigatoriedade de cada questão (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Página própria em `/validacao-inscricao/inscricoes/:inscricaoId/detalhe` (Detalhe da Inscrição), aberta em nova aba a partir da Fila de Validação: cabeçalho com identificação e protocolo, indicadores de progresso (preenchimento do formulário, contagem de documentos, contagem de membros da equipe e progresso dos termos), seções retráteis (dados do formulário, questionário, documentos com pré-visualização e download por endereço individual de cada documento, equipe em cards e termos), histórico em linha do tempo e as ações de decisão conforme a situação. O endereço de um documento não dispensa a conferência do direito à inscrição a cada acesso, e é o mesmo mecanismo que atende o download de anexo pelo avaliador alocado, fora desta tela (`AVL-AVA-03`). O bloco de Conferência de Ajustes e o acesso à Auditoria de Ajustes são atendidos pelas features do Feature Set Ajustes da Inscrição (VAL-AJU).

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Exibe "Carregando…" enquanto o detalhe é recuperado |
| Erro de validação | Não se aplica (tela de leitura) |
| Erro de servidor | Exibe "Não foi possível carregar os dados." |
| Sucesso | Exibe o detalhe completo da inscrição, com cada documento acessível pelo seu endereço individual, e as ações permitidas pela situação |
| Empty state | Seção sem conteúdo (ex.: sem documentos ou sem equipe): "Nenhum registro encontrado." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | O detalhe exibe formulário, questionário, documentos, equipe, termos e histórico de validação | cenário "Abrir o detalhe completo da inscrição" |
| SC-02 | As ações de decisão disponíveis correspondem à situação da inscrição | cenário "Ações disponíveis para inscrição finalizada" |
| SC-03 | Uma inscrição já decidida apresenta o parecer e a data do veredito | cenário "Veredito de inscrição já decidida" |
| SC-04 | Cada documento anexado é baixado por um endereço individual próprio, sem expor os demais documentos da inscrição | cenário "Endereço individual por documento anexado" |
| SC-05 | O download por esse endereço é negado a quem não tem direito à inscrição | cenário "Download de documento por quem não tem direito à inscrição" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Detalhar Inscrição | principal | SE | 5 | 37 | Complexo | 7 | 2026-02-28 |

### Memória de cálculo

**Detalhar Inscrição** — SE · ALR 5 · DER 37 · Complexo · 7 PF

```json
{"pe": "Detalhar Inscrição",
 "alr": ["Inscrição", "Premiação", "Categoria", "Modalidade", "Tipo de Participante"],
 "der": ["Inscrição", "Status", "E-mail (cabeçalho)", "Prêmio", "Categoria", "Modalidade", "Tipo de Participante", "Percentual Campos Preenchidos", "Qtd Premios Preenchidos", "Qtd arquivos anexados", "Qtd membros cadastrados", "Qtd termos aceitos", "CPF", "Data", "UF", "Anexo", "Termos", "E-mail (formulário)", "Número", "Qtd Questoes do formulário", "Título questão", "Obrigatoriedade questão", "Resposta questão", "Nome arquivo", "Tipo arquivo", "Data anexo", "Tamanho", "Equipe", "E-mail equipe", "Telefone", "CPF membro equipe", "Número Termo", "Data/Hora aceite", "Histórico de Status", "Data/hora mudança de status", "Comentário", "Ação"]}
```

Por que cada ALR:
1. `Inscrição` — o detalhe lê a inscrição e os seus subgrupos: respostas do formulário e do questionário, documentos, membros da equipe, aceites de termo e histórico de situações
2. `Premiação` — identifica a premiação da inscrição no cabeçalho
3. `Categoria` — identifica a categoria da inscrição no cabeçalho
4. `Modalidade` — identifica a modalidade da inscrição no cabeçalho
5. `Tipo de Participante` — identifica o tipo de participante e traz o título e a obrigatoriedade das questões do questionário

⚠️ A planilha conta *E-mail* duas vezes — no cabeçalho da inscrição e entre os campos do formulário; aqui cada um leva entre parênteses o lugar onde aparece. Pelo CPM o mesmo DER conta uma vez; mantido como o baseline contou, a confirmar com a equipe de métricas.

⚠️ O banner de veredito (regra 3) lê o parecer e a data da decisão na Validação de Inscrição, declarada em `## Dados lidos e gravados`, que a planilha não enumera. Ficou o número da planilha; a divergência vai à equipe de métricas.

**Total: 7 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU e do ticket na `## Origem` (nenhum dos dois numera critérios: `—` e a prosa do que a feature realiza), coluna Entidade em `## Campos` (o Preenchimento, que trazia o nome da entidade, passa a `exibido do cadastro`), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature, o DER *E-mail* repetido desambiguado e o porquê de cada ALR. Sem mudança de regra, cenário ou número de PF |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/validacao/analise-decisao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Download de documento por endereço individual e seguro, conferido a cada acesso a quem tem direito à inscrição — mesmo mecanismo que habilita o download de anexo pelo avaliador (`AVL-AVA-03`) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-018 |

---

*Feature Set: Análise e Decisão · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
