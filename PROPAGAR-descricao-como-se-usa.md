<!-- docqui: 2.16.0 | prompt: — | atualizado: 2026-09-02 -->
# Replicar: a segunda camada da `## Descrição` — o "como se usa"

> **O que é este arquivo.** Uma ordem de serviço para levar a outros repositórios de documentação — outras instâncias docqui, e o `siesa-engine` quando a cópia de lá estiver atrás — a convenção que faz a `## Descrição` do N3 ter **duas camadas**. Ele é **transitório**: propagado e conferido, apague-o.

---

## 1. A convenção

A `## Descrição` de um N3 são **dois parágrafos consecutivos**, e não uma seção só:

| Parágrafo | O que diz | Medido pelo FD-8? |
|---|---|---|
| 1º — **o contrato de entrega** | o que a feature entrega, em 1–2 frases de negócio, para quem nunca viu o sistema. Fórmula: *"Permite que [ator] [ação] [entidade], [resultado observável]."* | **sim** |
| 2º — **como se usa** | como se opera a funcionalidade: por onde se chega, o que se informa, o que se aciona. Em Job/CLI: o que dispara a execução | não |

Ao citar um conjunto de opções no 2º parágrafo — filtros, colunas, ações —, cite **até três**, precedidas de "como…". Se o conjunto tem três ou menos, liste todas e dispense o "como".

**O "como se usa" não vira seção própria.** A razão está escrita no template: separado da entrega, o texto do uso caía longe dela, e as duas camadas se leem melhor juntas.

---

## 2. Onde a convenção está definida hoje

Três artefatos a sustentam, e os três precisam viajar juntos. Faltando qualquer um, a convenção existe no papel e não se aplica — ou pior, se aplica ao contrário.

| Artefato | O que carrega | Se faltar |
|---|---|---|
| `engine/prompts/PROMPT_3A_N3_negocio.md` → gabarito da `## Descrição` | o placeholder `[SEGUNDO PARÁGRAFO — COMO SE USA: …]` logo abaixo do da entrega | quem escreve o N3 não sabe que existe a 2ª camada e entrega só a 1ª |
| `engine/templates/modules/_template-dominio/_template-feature-set/_template-feature.md` | o comentário invisível com a regra por extenso, a regra dos "até três precedidas de como…" e o motivo de não virar seção | o template gera N3 com um parágrafo só |
| `scripts/validate-feature-semantics.mjs` → função `descriptionText` | lê **apenas o primeiro parágrafo** da seção para medir o FD-8 | o FD-8 mede as duas camadas como se fossem uma e **acusa toda feature de "Descrição longa"** — o efeito é a instância abandonar a 2ª camada para calar o validador |

> ⚠️ **A ordem importa.** Levar o prompt e o template sem o validador é o pior dos mundos: os N3 saem com dois parágrafos e o gate reprova todos.

---

## 3. A lacuna que veio junto

`engine/FEATURE-DEFINITION.md`, na seção **"Descrição — o contrato de entrega (FD-8)"**, descreve **só a primeira camada**. Não menciona o segundo parágrafo em lugar nenhum — conferido por busca literal por "como se usa", "duas camadas" e "segundo parágrafo": nenhuma ocorrência.

Ou seja: o documento que **define** o que é uma Descrição não sabe que ela tem duas camadas, enquanto o prompt, o template e o validador sabem. Quem for consertar isso, acrescente ali um parágrafo dizendo que a seção tem duas camadas e que o FD-8 mede a primeira — é a fonte que as outras três citam.

---

## 4. O que fazer no repositório de destino

> ⚠️ **Ordem obrigatória**: o **engine sobe primeiro** e só depois as instâncias. Sincronizar uma instância a partir de um engine cujo conserto ainda não está na `main` dele **reverte o conserto em silêncio** (CLAUDE.md → *Ordem do push*).

### 4.1 `engine/prompts/PROMPT_3A_N3_negocio.md`

No gabarito do N3, logo abaixo do placeholder da Descrição, acrescentar:

```
[SEGUNDO PARÁGRAFO — COMO SE USA: uma ou duas frases de como se opera a funcionalidade (por onde se chega, o que se informa, o que se aciona) ou, em Job/CLI, do que dispara a execução. É a 2ª camada da descrição e mora aqui, não em seção própria. Só o 1º parágrafo é medido pelo FD-8. Ao citar um conjunto de opções, cite até três precedidas de "como…"]
```

### 4.2 `engine/templates/.../_template-feature.md`

No comentário invisível que precede a `## Descrição`, acrescentar o bloco **SEGUNDO PARÁGRAFO — COMO SE USA** (copiar do template deste repositório), e no corpo do template o segundo placeholder:

```
[Uma ou duas frases de COMO SE USA: por onde se chega, o que se informa e o que
se aciona — ou, em Job/CLI, o que dispara a execução.]
```

### 4.3 `scripts/validate-feature-semantics.mjs`

A função `descriptionText` precisa parar no **primeiro parágrafo**: acumula linhas não vazias e interrompe na primeira linha em branco depois de já ter acumulado alguma (e no `---`). É esse recorte que faz o FD-8 medir só a entrega. Copiar a função inteira deste repositório, com o comentário que explica o porquê.

### 4.4 Instâncias já existentes

Depois de o engine estar **mesclado e conferido na `main`**, use o `scripts/sync-instance.mjs` **do `siesa-engine`** — nunca `cp`. O script separa o drift por direção e recusa sobrescrever o que a instância tem à frente do canônico; a cópia manual não sabe disso e reverte em silêncio.

Os N3 **já escritos** não ganham a segunda camada sozinhos: a convenção vale dali para a frente, e a passada nos antigos é trabalho de redação, não de script. Não tente gerar o "como se usa" em lote — ele diz por onde se chega e o que se aciona, coisa que só sai lendo a feature.

---

## 5. Como conferir que pegou

Não basta ver o texto no prompt: **injete um caso que deve falhar e confirme que a checagem acusa** (CLAUDE.md → *Verificar de verdade*).

1. Escolha um N3 cuja Descrição já tenha os dois parágrafos e rode o validador — tem de passar sem apontar FD-8.
2. **Funda os dois parágrafos num só** (troque a linha em branco entre eles por um espaço) e rode de novo: o FD-8 tem de acusar **"Descrição longa (mais que ~2 frases)"**. Desfaça.
3. Se o passo 2 **não** acusar, o recorte do primeiro parágrafo não está lá — o validador está lendo a seção inteira e a convenção não está valendo.

Foi exatamente esse o teste feito aqui, em `modules/validacao/fila-validacao/f-exportar-historico-painel.md`: com dois parágrafos o FD-8 fica calado; fundidos num só, ele acusa; restaurado, cala de novo.

---

## 6. Origem

Convenção implementada no `premio-iel`; este arquivo a descreve para replicação em 2026-09-02.
