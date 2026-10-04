<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: AVL-ALO-04
feature_set: AVL-ALO
dominio: AVL
entidade: Avaliação de Inscrição
data_model_ref: data-models/avaliacao.md#avaliação-de-inscrição
endpoints: []
error_codes: []
depende_de: ["AVL-ALO-02"]
origem:
  tipo: issue
  chave: HU-025_Alocar_Avaliadores
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

# Alocar Avaliador à Inscrição
> **Nível 3** - Feature Set: Alocação de Avaliadores — Major Feature Set: Avaliação - `AVL-ALO-04`

## Descrição
Permite ao administrador designar, a partir do pool do grupo, os avaliadores específicos de cada inscrição elegível de uma etapa, registrando a alocação de quem avaliará cada projeto.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-025_Alocar_Avaliadores`](../../../hus/HU-025_Alocar_Avaliadores.docx) | Criação | — |
| [`PDTIC25093-60`](../../../analise-impacto/AIM-PDTIC25093-60.md) | Alteração | — |

---

<div class="dev-only">

## Superfície

**Tela própria** — rota `/avaliacao-admin/alocacao-participante` (Alocação por Inscrição): lista de inscrições elegíveis com a designação de avaliadores por inscrição, os filtros de grupo, estado e situação da alocação e o drawer lateral "Projeto" com o detalhe da inscrição.

**Fidelidade ao protótipo**: referência — `prototypes/avaliacao/alocacao/flow.html`

---

</div>

## Regras de negócio

1. As inscrições elegíveis à alocação são, na primeira etapa, as inscrições validadas e, nas etapas seguintes, as inscrições classificadas na etapa anterior — a marca de premiada não determina o avanço. ⚠️ *(quem avança é o classificado — mesma leitura da SP05 adotada em `AVL-APU-03`, a confirmar com a liderança do prêmio)*
2. Só avaliadores presentes no pool do grupo da inscrição podem ser designados a ela naquela etapa.
3. A quantidade de avaliadores esperada por inscrição é única para toda a premiação; a designação admite de zero a N avaliadores por inscrição, com sub-alocação e sobre-alocação permitidas.
4. O nome e o login do avaliador são preservados no momento da alocação e permanecem inalterados no histórico da inscrição.
5. Ao retirar um avaliador de uma inscrição, as notas que ele havia registrado nessa inscrição deixam de valer por exclusão lógica.
6. O administrador regional designa avaliadores apenas nas inscrições das UFs vinculadas ao seu perfil.
7. O grupo que qualifica uma inscrição para a alocação combina categoria, modalidade, tipo de participante e submodalidade da oferta a que a inscrição pertence. ✅ *(conferência com o código, 2026-08-28: as duas leituras coexistem por finalidades distintas — o **grupo de alocação** de `AVL-ALO-01`/`AVL-ALO-02` é categoria × modalidade × tipo de participante, enquanto o **grupo competitivo** usado aqui e na apuração acrescenta a submodalidade, que no produto é o enquadramento. Ver `global/CONFORMIDADE-CODIGO.md` § 3.2.)*
8. As inscrições sem unidade federativa vinculada compõem o conjunto Nacional para efeito de recorte por estado.
9. A situação da alocação de uma inscrição deriva da comparação entre a quantidade de avaliadores designados e a quantidade esperada por inscrição: sem avaliadores, alocação incompleta, alocação completa ou acima do esperado.
10. O detalhe do projeto consultado durante a alocação é somente leitura e apresenta o **mesmo conteúdo** definido para o detalhe da inscrição — identificação, respostas informadas pelo participante, anexos e equipe. → ver `VAL-ANA-01` (Detalhar Inscrição), que é a definição única desse conteúdo *(decidido em 2026-09-01: as duas visões convergem, e uma alteração no detalhe da inscrição alcança também este drawer)*

---

## Cenários

```gherkin
Feature: Alocar Avaliador à Inscrição

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Designar avaliadores a uma inscrição
    Given que a inscrição é elegível e o pool do grupo tem avaliadores
    When designo avaliadores do pool para a inscrição e salvo
    Then o sistema registra a alocação e exibe "Registro salvo com sucesso."

  Scenario: Consultar o detalhe do projeto durante a alocação
    Given que estou na lista de inscrições elegíveis da etapa
    When abro o detalhe do projeto de uma inscrição
    Then o sistema apresenta a identificação, as respostas do participante, os anexos e a equipe da inscrição sem sair da lista de alocação

  Scenario: Recortar a lista por grupo
    Given que a etapa tem inscrições de mais de um grupo
    When seleciono um ou mais grupos no recorte
    Then o sistema apresenta apenas as inscrições dos grupos selecionados

  Scenario: Recortar a lista pelas inscrições sem unidade federativa
    Given que a etapa tem inscrições sem unidade federativa vinculada
    When seleciono Nacional no recorte por estado
    Then o sistema apresenta apenas as inscrições sem unidade federativa

  Scenario: Recortar a lista por situação da alocação
    Given que a etapa tem inscrições com e sem avaliadores designados
    When seleciono a situação Sem avaliadores no recorte
    Then o sistema apresenta apenas as inscrições sem nenhum avaliador designado

  Scenario: Combinar recortes de grupo, estado e situação
    Given que selecionei um grupo, um estado e uma situação da alocação
    When aplico os critérios selecionados
    Then o sistema apresenta apenas as inscrições que atendem a todos os critérios e mantém visíveis os critérios aplicados

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Sobre-alocação acima do esperado
    Given que a premiação espera dois avaliadores por inscrição
    When designo três avaliadores para a inscrição e salvo
    Then o sistema registra a alocação mesmo acima da quantidade esperada

  Scenario: Inscrições elegíveis na primeira etapa
    Given que estou na primeira etapa da premiação
    When abro a alocação por inscrição
    Then o sistema apresenta como elegíveis as inscrições validadas

  Scenario: Recorte sem inscrições correspondentes
    Given que nenhuma inscrição elegível corresponde aos critérios selecionados
    When aplico os critérios
    Then o sistema exibe "Nenhum resultado para a busca."

  Scenario: Detalhe do projeto sem alteração da inscrição
    Given que abri o detalhe do projeto de uma inscrição
    When consulto os dados apresentados
    Then o detalhe permanece em modo leitura e os dados informados pelo participante seguem inalterados

  # ── Conflitos com dados existentes ─────────────────────────────

  Scenario: Remover avaliador que já registrou notas
    Given que confirmo a remoção de um avaliador que já pontuou a inscrição
    When salvo a alocação sem esse avaliador
    Then o sistema remove o avaliador e desativa as notas que ele havia registrado na inscrição
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Premiação | entrada do usuário | editável | seleção → Premiação | sim | premiações ativas |
| Etapa | entrada do usuário | editável | seleção → Etapa | sim | etapas da premiação selecionada |
| Avaliadores alocados | entrada do usuário | editável | multi-seleção → Avaliador | não | limitado ao pool do grupo da inscrição na etapa |
| Grupo | entrada do usuário | editável | seleção múltipla → Grupo (categoria, modalidade, tipo de participante e submodalidade) | não | grupos com inscrições elegíveis na etapa selecionada |
| Estado | entrada do usuário | editável | seleção múltipla → UF, com a opção Nacional | não | UFs alcançadas pelo perfil; Nacional reúne as inscrições sem unidade federativa |
| Situação da alocação | entrada do usuário | editável | seleção múltipla (Sem avaliadores, Alocação incompleta, Alocação completa, Acima do esperado) | não | — |

---

## Colunas do resultado

| Coluna (Label PO) | Origem | Ordenação |
|---|---|---|
| Protocolo | Inscrição | padrão ↑ |
| Participante / Projeto | Inscrição | — |
| Grupo | derivado | — |
| Estado | Inscrição (unidade federativa; Nacional quando ausente) | — |
| Avaliadores alocados | Avaliação de Inscrição | — |
| Situação da alocação (N/M) | derivado (Sem avaliadores, Alocação incompleta, Alocação completa, Acima do esperado) | — |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Nome do avaliador | Nome vigente no cadastro corporativo | No momento da alocação à inscrição |
| Login do avaliador | Login vigente no cadastro corporativo | No momento da alocação à inscrição |
| Status da avaliação | A iniciar | Ao designar o avaliador à inscrição |
| Situação da alocação | Sem avaliadores, Alocação incompleta, Alocação completa ou Acima do esperado, conforme a quantidade de avaliadores designados frente à esperada | A cada alocação salva na inscrição |
| Estado da inscrição | Nacional, quando a inscrição não tem unidade federativa vinculada | Ao apresentar e recortar as inscrições por estado |

---

## Comportamento de tela

### Onde fica
Página própria em `/avaliacao-admin/alocacao-participante` (Alocação por Inscrição): seletores de premiação e etapa, o indicador de avaliadores esperados por inscrição, a barra de filtros em multisseleção — Grupo, Estado (com a opção Nacional) e Situação da alocação —, cujos critérios aplicados ficam visíveis como chips removíveis acima da lista, e a lista de inscrições elegíveis, cada uma com a designação de avaliadores, a etiqueta de situação e a ação que abre o drawer "Projeto": painel lateral em modo leitura, sobre a própria lista, com a identificação da inscrição, as respostas do participante, os anexos e a equipe, que ao fechar devolve a lista no mesmo ponto.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Salvar" da inscrição desabilitado com indicador enquanto grava; o drawer "Projeto" exibe "Carregando…" enquanto o detalhe é recuperado |
| Erro de validação | Não se aplica (designação opcional por inscrição) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Exibe "Registro salvo com sucesso." e atualiza a situação da inscrição, mantendo os filtros aplicados |
| Empty state | Sem inscrições elegíveis: "Nenhum registro encontrado."; sem correspondência aos filtros aplicados: "Nenhum resultado para a busca." |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma inscrição elegível recebe avaliadores do pool do seu grupo, com sub e sobre-alocação permitidas | Regra de negócio (HU-025) |
| SC-02 | A remoção de um avaliador desativa em cascata as notas que ele havia registrado na inscrição | cenário "Remover avaliador que já registrou notas" |
| SC-03 | A lista de inscrições elegíveis é recortada por grupo, por estado e por situação da alocação, com os critérios combinados entre si | cenário "Combinar recortes de grupo, estado e situação" |
| SC-04 | As inscrições sem unidade federativa são alcançadas pelo recorte Nacional | cenário "Recortar a lista pelas inscrições sem unidade federativa" |
| SC-05 | O detalhe do projeto de uma inscrição é consultado sem sair da lista de alocação | cenário "Consultar o detalhe do projeto durante a alocação" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Consultar Alocação de Avaliadores por Participante | SE | 6 | 18 | Complexo | 7 | 2026-02-28 |
| Consultar Avaliadores por Inscrição | SE | 4 | 10 | Complexo | 7 | 2026-02-28 |
| Incluir Avaliadores para Inscrição | EE | 2 | 3 | Simples | 3 | 2026-02-28 |

### Memória de cálculo

- **Consultar Alocação de Avaliadores por Participante** — ALR (6): Alocação Avaliadores · Usuário · Avaliação de Inscrição · Categoria · Modalidade · Inscrição. DER (18): Premiação · Etapa · Grupo · Total de Inscrições · Participante · Projeto · Total avaliadores selecionados/necessários · Localidade · Categoria · Modalidade · Tipo de Participante · Avaliador · E-mail avaliador · Total avaliações alocadas · Total avaliações em andamento · Total avaliações finalizadas · Ação · Mensagem.

```json
{"pe": "Consultar Alocação de Avaliadores por Participante",
 "alr": ["Alocação Avaliadores", "Usuário", "Avaliação de Inscrição", "Categoria", "Modalidade", "Inscrição"],
 "der": ["Premiação", "Etapa", "Grupo", "Total de Inscrições", "Participante", "Projeto", "Total avaliadores selecionados/necessários", "Localidade", "Categoria", "Modalidade", "Tipo de Participante", "Avaliador", "E-mail avaliador", "Total avaliações alocadas", "Total avaliações em andamento", "Total avaliações finalizadas", "Ação", "Mensagem"]}
```
- **Consultar Avaliadores por Inscrição** — ALR (4): Premiação · Categoria · Modalidade · Tipo Participante. DER (10): Participante · Projeto · Etapa · Localidade · Avaliador · E-mail avaliador · Total avaliações alocadas · Total avaliações em andamento · Total avaliações finalizadas · Ação.

```json
{"pe": "Consultar Avaliadores por Inscrição",
 "alr": ["Premiação", "Categoria", "Modalidade", "Tipo Participante"],
 "der": ["Participante", "Projeto", "Etapa", "Localidade", "Avaliador", "E-mail avaliador", "Total avaliações alocadas", "Total avaliações em andamento", "Total avaliações finalizadas", "Ação"]}
```
- **Incluir Avaliadores para Inscrição** — ALR (2): Premiação · Alocação Avaliadores. DER (3): ID Avaliador · Ação · Mensagem.

```json
{"pe": "Incluir Avaliadores para Inscrição",
 "alr": ["Premiação", "Alocação Avaliadores"],
 "der": ["ID Avaliador", "Ação", "Mensagem"]}
```

**Total: 17 PF** (3 processos elementares).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Estrutura atualizada | Artefato regenerado com o engine 4.1.0: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, `## Origem` com a HU e os tickets das AIMs, Gherkin com `Feature:` |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (3 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-02 | Protótipo (docqui) | Vínculo corrigido | A linha dizia **n/a** embora a feature já estivesse desenhada em `prototypes/avaliacao/alocacao/flow.html` desde a geração daquele fluxo — o manifesto registrava o vínculo e este N3 não. Fidelidade passa a **referência** |
| 2026-09-01 | Decisões de produto (docqui) | Regra confirmada | Decidido que o drawer "Projeto" **reaproveita** a visão de `VAL-ANA-01` Detalhar Inscrição: a RN10 passa a referenciá-la como definição única do detalhe da inscrição, em vez de descrever um conteúdo paralelo |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Impacto SP05 (docqui) | Feature alterada | Detalhe do projeto consultável durante a alocação (drawer "Projeto") e recortes por grupo, estado (com Nacional) e situação da alocação; situação da alocação com valores explícitos; elegibilidade das etapas seguintes alinhada ao classificado |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-025 |

---

*Feature Set: Alocação de Avaliadores · Major Feature Set: Avaliação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
