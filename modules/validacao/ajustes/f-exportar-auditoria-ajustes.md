---
id: VAL-AJU-03
feature_set: VAL-AJU
dominio: VAL
entidade: Snapshot da Inscrição
prioridade: P3
mvp: false
data_model_ref: data-models/inscricao.md#snapshot-da-inscricao
endpoints: []
error_codes: []
depende_de: [VAL-AJU-01, VAL-AJU-02]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Exportar Auditoria de Ajustes
> **Nível 3** - Feature Set: Ajustes da Inscrição — Domínio: Validação - `VAL-AJU-03`
> **Prioridade**: P3 · **MVP**: não

## Descrição
Permite ao validador exportar em CSV todas as rodadas de ajuste fechadas de uma inscrição, gerando uma linha por alteração para servir de evidência documental.

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

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Rodadas exportadas | derivado | somente leitura | todas as rodadas de ajuste fechadas da inscrição | — | apenas rodadas com solicitação e reenvio |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Nome do arquivo | auditoria_[identificação da inscrição]_[data e hora].csv | Ao exportar |
| Conteúdo do arquivo | uma linha por alteração de todas as rodadas fechadas | Ao exportar |
| Formato do arquivo | separador ponto e vírgula, codificação compatível com Excel em português | Ao exportar |

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

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| Exportar Auditoria de Ajustes para CSV | CE | 2 | 11 | Médio | 4 | 2026-02-28 |

### Memória de cálculo

- **Exportar Auditoria de Ajustes para CSV** — ALR (2): Inscrição · Tipo de Participante. DER (11): Rodada · Data Antes · Data Depois · Superficie · Id Registro · Registro · Campo · Valor Antes · Valor Depois · Tipo Operacao · Ação.

```json
{"pe": "Exportar Auditoria de Ajustes para CSV",
 "alr": ["Inscrição", "Tipo de Participante"],
 "der": ["Rodada", "Data Antes", "Data Depois", "Superficie", "Id Registro", "Registro", "Campo", "Valor Antes", "Valor Depois", "Tipo Operacao", "Ação"]}
```

**Total: 4 PF** (1 processo elementar).

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-10-04 | migra-enumeracao | Contagem | Enumeração de ALR e DER da memória de cálculo em bloco JSON (1 PE) — migra-enumeracao; sem mudança de número |
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-27 | Engenharia reversa (docqui) | Feature criada | N3 negocial derivado da HU-026 |

---

*Feature Set: Ajustes da Inscrição · Domínio: Validação · Última revisão: 2026-08-27*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
