<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
---
id: VAL-AJU-03
feature_set: VAL-AJU
dominio: VAL
entidade: Snapshot da Inscrição
data_model_ref: data-models/inscricao.md#snapshot-da-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-AJU-01, VAL-AJU-02]
origem:
  tipo: issue
  chave: HU-026_Auditoria_Ajustes_Inscricao
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

# Exportar Auditoria de Ajustes
> **Nível 3** - Feature Set: Ajustes da Inscrição — Major Feature Set: Validação - `VAL-AJU-03`

## Descrição
Permite ao validador exportar em CSV todas as rodadas de ajuste fechadas de uma inscrição, gerando uma linha por alteração para servir de evidência documental.

No popup de Auditoria de Ajustes, aberto a partir do Detalhe da Inscrição, o validador aciona "Exportar CSV" e recebe o arquivo com todas as rodadas fechadas da inscrição, qualquer que seja a rodada em consulta.

---

## Origem

| Ticket (AIM) | Tipo | Critérios cobertos |
|---|---|---|
| [`HU-026_Auditoria_Ajustes_Inscricao`](../../../hus/HU-026_Auditoria_Ajustes_Inscricao.docx) | Criação | — exportação em CSV de todas as rodadas fechadas da inscrição num único arquivo, uma linha por alteração, com o cabeçalho fixo, o separador ponto e vírgula e o nome com a identificação da inscrição e a data e hora |

---

<div class="dev-only">

## Superfície

**Ação em tela** — origem: Auditoria de Ajustes, a partir do Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`)

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A exportação só está disponível quando existe ao menos uma rodada de ajuste fechada.
2. A exportação inclui todas as rodadas fechadas da inscrição, não apenas a rodada em consulta.
3. O arquivo exportado gera uma linha por alteração.
4. A exportação da auditoria de uma inscrição só é permitida ao validador vinculado à unidade federativa da inscrição.

---

## Cenários

```gherkin
Feature: Exportar Auditoria de Ajustes

  # ← MESSAGE-DICTIONARY: BASELINE

  # ── Caminho feliz ──────────────────────────────────────────────

  Scenario: Exportar a auditoria de ajustes
    Given que a inscrição tem rodadas de ajuste fechadas
    When aciono a exportação da auditoria
    Then o sistema gera um arquivo CSV com todas as rodadas fechadas, uma linha por alteração

  Scenario: Conteúdo do arquivo exportado
    Given que exportei a auditoria de ajustes
    When abro o arquivo gerado
    Then cada linha traz a rodada, a superfície, o registro, o campo, o valor anterior, o valor novo e o tipo de alteração

  # ── Estados especiais ──────────────────────────────────────────

  Scenario: Inscrição sem rodada fechada
    Given que a inscrição não tem nenhuma rodada de ajuste fechada
    When acesso o detalhe da inscrição
    Then a exportação da auditoria não fica disponível
```

---

## Campos

| Label PO | Entidade | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|---|
| Rodadas exportadas | Snapshot da Inscrição | calculado | somente leitura | lista (todas as rodadas de ajuste fechadas da inscrição) | — | apenas rodadas com solicitação e reenvio |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Nome do arquivo | auditoria_[identificação da inscrição]_[data e hora].csv | Ao exportar |
| Conteúdo do arquivo | uma linha por alteração de todas as rodadas fechadas | Ao exportar |
| Formato do arquivo | separador ponto e vírgula, codificação compatível com Excel em português | Ao exportar |

---

## Dados lidos e gravados

| Entidade | Papel | Por que a feature a toca |
|---|---|---|
| Tipo de Participante | lê | Os rótulos dos registros e dos campos de cada alteração exportada vêm da configuração do formulário, das questões e dos anexos do tipo de participante (ALR do baseline) |

---

## Comportamento de tela

### Onde fica
Ação disparada pelo botão "Exportar CSV" no popup de Auditoria de Ajustes, aberto a partir do Detalhe da Inscrição (`/validacao-inscricao/inscricoes/:inscricaoId/detalhe`). A exportação abrange todas as rodadas fechadas da inscrição, independentemente da rodada em consulta no popup.

### Estados da tela

| Estado | Comportamento |
|---|---|
| Loading | Botão "Exportar CSV" desabilitado com indicador enquanto o arquivo é gerado |
| Erro de validação | Não se aplica (ação sem formulário) |
| Erro de servidor | Exibe "Ocorreu um erro. Tente novamente." |
| Sucesso | Disponibiliza o arquivo CSV para download |
| Empty state | Sem rodadas fechadas: a exportação não fica disponível |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | A exportação gera um CSV com todas as rodadas fechadas, uma linha por alteração | cenário "Exportar a auditoria de ajustes" |
| SC-02 | Cada linha do arquivo traz rodada, superfície, registro, campo, valores anterior e novo e o tipo de alteração | cenário "Conteúdo do arquivo exportado" |

---

## Métricas de tamanho

> Contagem do baseline APF (`arquivos/PIEL_BASELINE_PF_CD.xlsx`, aba *AFP - Detalhada*, coluna **PFB**), elaborada pela equipe de métricas em 2026-02-28. A memória de cálculo abaixo — os ALR e DER nomeados — vem da própria planilha.

| Função de Transação | Papel | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|---|
| Exportar Auditoria de Ajustes | principal | CE | 2 | 11 | Médio | 4 | 2026-02-28 |

> No baseline, o processo elementar se chama *Exportar Auditoria de Ajustes para CSV*; aqui leva o nome da feature, como pede o `global/SIZING.md` para o `principal`. O número é o do baseline.

### Memória de cálculo

**Exportar Auditoria de Ajustes** — CE · ALR 2 · DER 11 · Médio · 4 PF

```json
{"pe": "Exportar Auditoria de Ajustes",
 "alr": ["Inscrição", "Tipo de Participante"],
 "der": ["Rodada", "Data Antes", "Data Depois", "Superficie", "Id Registro", "Registro", "Campo", "Valor Antes", "Valor Depois", "Tipo Operacao", "Ação"]}
```

Por que cada ALR:
1. `Inscrição` — a exportação lê as capturas de antes e depois de todas as rodadas fechadas (subgrupo do mesmo arquivo lógico)
2. `Tipo de Participante` — resolve os rótulos dos registros e dos campos de cada alteração

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | Regeneração 4.1.0 (docqui) | Regenerado | Artefato regenerado com o engine 4.1.0. Estrutura: carimbo, front-matter do perfil `requisitos` (sem `prioridade`/`mvp`, com os blocos `origem` e `contagem`), subtítulo e rodapé com *Major Feature Set*, Gherkin com `Feature:`. Redação: segundo parágrafo da Descrição (como se usa), critérios da HU na `## Origem` (a HU não numera critérios: `—` e a prosa do que a feature realiza), coluna Entidade em `## Campos` (com o Preenchimento `derivado` passando a `calculado`), `## Dados lidos e gravados`, coluna Papel e memória de cálculo em bloco JSON, com o processo elementar principal levando o nome da feature (no baseline, *Exportar Auditoria de Ajustes para CSV*) e o porquê de cada ALR. Sem mudança de regra, cenário ou número de PF |
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-026 |

---

*Feature Set: Ajustes da Inscrição · Major Feature Set: Validação · Última revisão: 2026-10-04*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
