<!-- docqui: 2.8.0 | prompt: PROMPT_3A | atualizado: 2026-08-28 -->
---
id: CFG-PRE-13
feature_set: CFG-PRE
dominio: CFG
entidade: Branding da Premiação
prioridade: P2
mvp: false
data_model_ref: data-models/configuracao.md#branding-da-premiacao
endpoints: []
error_codes: []
depende_de: [CFG-PRE-02]
estado: rascunho
gates:
  requisitos:   { aprovado: false, por: "", em: "", pr: "" }
  modelo-dados: { aprovado: false, por: "", em: "", pr: "" }
  testes:       { aprovado: false, por: "", em: "", pr: "" }
  codigo:       { aprovado: false, por: "", em: "", pr: "" }
---

# Carregar Imagem de Configuração
> **Nível 3** - Feature Set: Prêmios — Domínio: Configuração da Premiação - `CFG-PRE-13`
> **Prioridade**: P2 · **MVP**: não

## Descrição
Permite ao administrador subir as imagens que compõem a identidade visual da premiação — logotipo, banner e ícone — e obter o endereço público de cada uma, para uso na página de inscrição.

---

<div class="dev-only">

## Superfície

**API** — consumidor previsto: tela de identidade visual da premiação

⚠️ **Parcialmente implementada** (conferência com o código, 2026-08-28): a operação de carga e o endereço público das imagens existem no servidor, mas **nenhuma tela do sistema as utiliza** — a identidade visual da premiação só é preenchida hoje pela importação da planilha da edição (`CFG-PRE-06`) e apenas consumida na página do link público. Ver `global/CONFORMIDADE-CODIGO.md` § 4.

**Fidelidade ao protótipo**: n/a

---

</div>

## Regras de negócio

1. A imagem carregada tem no máximo 5 MB.
2. Os formatos aceitos são PNG, JPEG, WebP e SVG.
3. Cada imagem carregada recebe um endereço público próprio, acessível sem autenticação.
4. O endereço público de uma imagem também serve uma versão reduzida dela, para uso em pré-visualizações.
5. Remover uma imagem torna o seu endereço público inacessível.
6. A imagem carregada só passa a valer na página de inscrição depois de referenciada na identidade visual da premiação. → ver DATA-MODEL.md: Entidade Branding da Premiação

---

## Cenários

```gherkin
# ← MESSAGE-DICTIONARY: BASELINE

# ── Caminho feliz ──────────────────────────────────────────────

Scenario: Carregar o logotipo da premiação
  Given que estou configurando a identidade visual de uma premiação
  When carrego um arquivo PNG de 800 KB
  Then o sistema aceita a imagem e devolve o endereço público em que ela pode ser exibida

Scenario: Remover uma imagem carregada
  Given que uma imagem já foi carregada
  When removo essa imagem
  Then o endereço público dela deixa de responder

# ── Erros de validação ─────────────────────────────────────────

Scenario: Arquivo acima do tamanho permitido
  When carrego uma imagem de 8 MB
  Then o sistema recusa a carga e informa que o limite é de 5 MB

Scenario: Formato não aceito
  When carrego um arquivo em formato diferente de PNG, JPEG, WebP ou SVG
  Then o sistema recusa a carga e informa quais formatos são aceitos

Scenario: Arquivo vazio
  When aciono a carga sem indicar o conteúdo do arquivo
  Then o sistema recusa a carga e informa que o conteúdo não foi enviado

# ── Restrições de acesso ───────────────────────────────────────

Scenario: Participante tenta carregar imagem
  Given que estou autenticado como Participante
  When tento carregar uma imagem de configuração
  Then o sistema nega a operação
```

---

## Campos

| Label PO | Preenchimento | Edição | Tipo | Obrigatório | Validação |
|---|---|---|---|---|---|
| Arquivo da imagem | entrada do usuário | editável | arquivo | sim | no máximo 5 MB; formatos PNG, JPEG, WebP ou SVG |
| Nome do arquivo | entrada do usuário | editável | texto | não | identifica a imagem para o administrador |

---

## Campos automáticos

| Label PO | Valor | Quando |
|---|---|---|
| Endereço público da imagem | endereço que exibe a imagem sem exigir autenticação | Ao concluir a carga |
| Tamanho do arquivo | tamanho em bytes do arquivo carregado | Ao concluir a carga |

---

## Execução e operação

### Como executa
Operação acionada pela tela de identidade visual da premiação ao escolher um arquivo de imagem. O administrador informa o arquivo e o sistema devolve o endereço público a ser gravado na identidade visual da premiação.

### Parâmetros de execução

| Parâmetro (Label PO) | Obrigatório | Efeito |
|---|---|---|
| Arquivo da imagem | sim | define a imagem a ser guardada e publicada |
| Nome do arquivo | não | identifica a imagem nas listagens do administrador |

### Interrupção e reexecução
A carga é atômica: interrompida no meio, nenhuma imagem é guardada e nenhum endereço é emitido. Repetir a carga do mesmo arquivo é seguro — gera uma nova imagem, com endereço próprio, sem substituir a anterior.

### Saídas e artefatos
A imagem guardada e o seu endereço público. A referência à imagem passa a valer na página de inscrição quando gravada na identidade visual da premiação — → ver DATA-MODEL.md: Entidade Branding da Premiação.

### Acompanhamento

| Situação | Como o ator percebe |
|---|---|
| Em andamento | Indicador de progresso enquanto o arquivo é enviado |
| Falha | Mensagem informando o motivo da recusa — tamanho, formato ou conteúdo ausente |
| Sucesso | O endereço público da imagem é devolvido e fica disponível para uso |

---

## Critérios de sucesso

| # | Critério mensurável | Origem |
|---|---|---|
| SC-01 | Uma imagem dentro do limite e em formato aceito recebe endereço público utilizável na página de inscrição | cenário "Carregar o logotipo da premiação" |
| SC-02 | Imagem acima de 5 MB ou em formato não aceito é recusada | cenários "Arquivo acima do tamanho permitido" e "Formato não aceito" |

---

## Métricas de tamanho

> **Sem contagem no baseline APF** — sem processo elementar correspondente. Ver `global/SIZING.md` → *Conciliação Feature ↔ Processo Elementar*.

| Função de Transação | Tipo | ALR | DER | Complexidade | PF | Data |
|---|---|---|---|---|---|---|
| — | — | — | — | — | — | — |

**Total: — PF.**

---

## Changelog

<!-- Ordem decrescente por data: a entrada mais recente fica sempre no topo, logo abaixo do cabeçalho. -->

| Data | Autor | Tipo | Descrição |
|---|---|---|---|
| 2026-09-01 | Carga do baseline (docqui) | Contagem registrada | Seção `## Métricas de tamanho` preenchida com o baseline APF de 2026-02-28, incluindo a memória de cálculo (ALR e DER nomeados) |
| 2026-08-28 | Conferência doc × código (docqui) | Feature criada | N3 derivado do código (carga e publicação de imagens da identidade visual) — capacidade implementada no servidor, sem tela que a consuma |

---

*Feature Set: Prêmios · Domínio: Configuração da Premiação · Última revisão: 2026-08-28*

*Links: [N2 do Feature Set](./README.md) · [N1 do domínio](../README.md) · [INDEX geral](../../INDEX.md)*
