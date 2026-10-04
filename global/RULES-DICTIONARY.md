<!-- docqui: {{VERSION}} | prompt: {{PROMPT_ID}} | atualizado: {{YYYY-MM-DD}} -->
# RULES-DICTIONARY.md
> Dicionário de **regras de negócio canônicas** — invariantes que se repetem em
> várias features (maioridade, registro vinculado não excluível, etc.).
>
> Registrá-las **uma vez** evita repetir (e divergir) a mesma regra em cada N3.
> Cada regra aqui descreve a **invariante** ("o quê"); a reação do sistema ("não
> salva", "exibe mensagem") vive nos **cenários**, não na regra.
>
> **Como referenciar nos N3**:
> - Regras de negócio: `→ ver RULES-DICTIONARY: [nome] (parâmetro: [valor])`
> - Cenários Gherkin: `# ← RULES-DICTIONARY: [nome] (importar cenários)`
> - Código (DEV): `// → RULES-DICTIONARY: [nome]`
>
> **Regra de uso**:
> - Modo PO: aplicar automaticamente; perguntar apenas os **parâmetros** em aberto.
> - Não confundir com NFR: qualidade do sistema (desempenho, segurança, auditoria)
>   vai para `global/NFR.md`, não aqui.

---

## Índice

| Regra | Invariante (resumo) | Parâmetros em aberto |
|---|---|---|
| Maioridade | A pessoa precisa ter idade mínima | idade mínima |
| Responsável ativo | O responsável vinculado precisa estar ativo | quem é o "responsável" |
| Período de vigência | Início ≤ fim; ação válida só dentro da vigência | datas / fuso |
| Aprovação antes de publicar | Conteúdo só publica após aprovação | quem aprova |
| Limite por organização | Quantidade máxima de registros por organização | limite |
| Slug único público | Identificador público é único e estável | escopo da unicidade |
| Reenvio com cooldown | Reenvio só após intervalo mínimo | janela de cooldown |
| Arquivo com tamanho máximo | Upload limitado em tamanho/tipo | tamanho e tipos aceitos |
| Registro vinculado não pode ser excluído | Não excluir registro referenciado por outro | entidade vinculada; ação alternativa |

---

## Entradas

> Formato de cada regra. Abaixo, exemplos trabalhados; replique para as demais.

### Maioridade
<!-- usado-em:gerado -->
> **Usado em:** _(ainda não referenciado em N3)_
<!-- /usado-em -->

- **Invariante**: a pessoa associada ao registro deve ter pelo menos a idade mínima na data de referência.
- **Parâmetros (por feature)**: idade mínima (ex.: 18); data de referência (cadastro / evento).
- **Mensagem**: "É necessário ter no mínimo [idade] anos."

```gherkin
# ── Regra: Maioridade ────────────────────────────────────────────
Scenario: Pessoa abaixo da idade mínima
  Given que a data de nascimento informada resulta em idade menor que [idade mínima]
  When tento salvar
  Then o sistema rejeita e exibe "É necessário ter no mínimo [idade] anos."
```

### Arquivo com tamanho máximo
<!-- usado-em:gerado -->
> **Usado em:** `AVL-ETA-07` · `CFG-PRE-06` · `CFG-TIP-12` · `INS-PAR-05`
<!-- /usado-em -->

- **Invariante**: o upload é aceito apenas se respeitar o tamanho e os tipos permitidos.
- **Parâmetros (por feature)**: tamanho máximo (ex.: 5 MB); tipos aceitos (ex.: PDF, PNG).
- **Mensagem**: "Arquivo excede o tamanho máximo de [tamanho]." / "Tipo de arquivo não permitido."

```gherkin
# ── Regra: Arquivo com tamanho máximo ────────────────────────────
Scenario: Arquivo acima do tamanho permitido
  Given que seleciono um arquivo maior que [tamanho máximo]
  When tento enviar
  Then o sistema rejeita e exibe "Arquivo excede o tamanho máximo de [tamanho]."
```

### Registro vinculado não pode ser excluído
<!-- usado-em:gerado -->
> **Usado em:** `AVL-ETA-04` · `CFG-TIP-09`
<!-- /usado-em -->

- **Invariante**: um registro referenciado por outros não pode ser removido enquanto houver vínculos.
- **Parâmetros (por feature)**: entidade(s) vinculada(s); ação alternativa (inativar em vez de excluir).
- **Mensagem**: "Não é possível excluir: existem [entidade] vinculados a este registro."

```gherkin
# ── Regra: Registro vinculado não pode ser excluído ──────────────
Scenario: Exclusão de registro com vínculos
  Given que o registro possui [entidade vinculada] associados
  When tento excluí-lo
  Then o sistema impede e exibe "Não é possível excluir: existem [entidade] vinculados a este registro."
```

---

## Como adicionar uma regra canônica

Uma regra vira canônica quando a **mesma invariante** aparece em **2+ features**
(detectável via auditoria — ver `PROMPT_AUDIT_RULES_DEDUP.md`). Para promovê-la:

1. Adicione a linha ao **Índice** (nome, invariante, parâmetros em aberto).
2. Crie a **entrada** (invariante, parâmetros, mensagem, cenários).
3. Nos N3 que repetiam a regra inline, substitua por
   `→ ver RULES-DICTIONARY: [nome]` e importe os cenários com o marcador.

> Regra que vale só para um domínio (não para o sistema todo) **não** é canônica:
> registre-a nas *Regras transversais* do N1 do domínio.

---

## Instrução para a LLM

Ao especificar regras de negócio em um N3 (PROMPT_3A/3B):
1. Verifique se a regra é canônica — se for, **não pergunte** sobre o comportamento;
   aplique e pergunte apenas os parâmetros em aberto.
2. Referencie `→ ver RULES-DICTIONARY: [nome] (parâmetro: [valor])` e importe os
   cenários com `# ← RULES-DICTIONARY: [nome]`.
3. Regra recorrente ainda não dicionarizada: proponha com ⚠️ e aguarde aprovação.
4. Se o que foi descrito é uma **qualidade do sistema** (não uma invariante de
   negócio), encaminhe ao `global/NFR.md`.

> **Usado em (não escreva à mão)**: abaixo de cada `### <entrada>` há um bloco
> `> **Usado em:** …` entre `<!-- usado-em:gerado -->` e `<!-- /usado-em -->`,
> **gerado** por `scripts/generate-usage-index.mjs` a partir das referências
> `→ ver`/`←` dos N3. Não edite esse bloco à mão — rode o gerador (o CI valida
> que está fresco). O backlink já vive na referência direta do N3; aqui é só a
> projeção reversa.
