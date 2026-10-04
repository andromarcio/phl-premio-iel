<!-- docqui: 4.1.0 | prompt: PROMPT_4A | atualizado: 2026-10-04 -->
# FIELD-DICTIONARY.md
> Dicionário de **campos canônicos** — campos que se repetem em várias features
> com a mesma semântica de validação (CPF, e-mail, telefone…).
>
> Registrá-los **uma vez** evita reespecificar validações em cada N3 e garante
> mensagens e cenários idênticos em todo o sistema.
>
> **Como referenciar nos N3**:
> - Tabela de campos: `→ ver FIELD-DICTIONARY: [nome]`
> - Cenários Gherkin: `# ← FIELD-DICTIONARY: [nome] (importar cenários de validação)`
>
> **Regra de uso**:
> - Modo PO: aplicar a validação automaticamente; perguntar apenas o que o
>   dicionário deixa em aberto — **obrigatoriedade** e **unicidade**.
> - Modo DEV: usar o **Label Dev** abaixo; não reescrever cenários — importá-los com o marcador.
> - Mensagens específicas de campo canônico vivem aqui e **têm precedência** sobre o MESSAGE-DICTIONARY.

---

## Índice

| Campo (Label PO) | Label Dev | Tipo | Resumo da validação |
|---|---|---|---|
| CPF | cpf | texto (11 dígitos) | 11 dígitos numéricos; dígitos verificadores válidos |
| CNPJ | cnpj | texto (14 dígitos) | 14 dígitos numéricos; dígitos verificadores válidos |
| CEP | cep | texto (8 dígitos) | 8 dígitos numéricos |
| Telefone | telefone | texto | DDD + número no formato nacional |
| E-mail | email | texto | formato de e-mail válido |
| Senha | senha | texto | política mínima de segurança |
| Data de nascimento | dataNascimento | data | data no passado; idade derivável |
| Data futura | [contexto] | data | não anterior à data atual |
| Valor monetário | valor | decimal | ≥ 0; 2 casas decimais |
| Percentual | percentual | decimal | entre 0 e 100 |
| Nome de pessoa | nomeCompleto | texto | nome e sobrenome; comprimento mínimo |
| Razão social | razaoSocial | texto | texto livre; comprimento mínimo |
| URL | url | texto | formato de URL válido (http/https) |

> Parâmetros sempre deixados em aberto para a feature: **obrigatoriedade** e **unicidade**.

---

## Entradas

> Formato de cada entrada. Abaixo, exemplos trabalhados dos campos mais comuns;
> replique o mesmo formato ao detalhar os demais do índice.

### CPF
<!-- usado-em:gerado -->
> **Usado em:** `AVL-ALO-03` · `CFG-TIP-07` · `CFG-TIP-08` · `INS-PAR-02` · `VAL-ANA-01`
<!-- /usado-em -->

- **Label Dev**: `cpf`
- **Tipo**: texto (11 dígitos, sem máscara no armazenamento)
- **Validação**: exatamente 11 dígitos numéricos; dígitos verificadores válidos.
- **Em aberto (por feature)**: obrigatoriedade; unicidade (ex.: único por organização).
- **Mensagem**: "CPF inválido." (→ ver MESSAGE-DICTIONARY se houver variação)

```gherkin
# ── Validação de campo: CPF ──────────────────────────────────────
Scenario: CPF com dígitos verificadores inválidos
  Given que informo um CPF com dígito verificador incorreto
  When tento salvar
  Then o sistema rejeita e exibe "CPF inválido."

Scenario: CPF com quantidade de dígitos diferente de 11
  Given que informo um CPF com menos de 11 dígitos
  When tento salvar
  Then o sistema rejeita e exibe "CPF inválido."
```

### E-mail
<!-- usado-em:gerado -->
> **Usado em:** `ACS-ACE-03` · `ACS-ADM-02` · `ACS-ADM-03` · `AVL-ALO-03` · `INS-PAR-01` · `INS-PAR-02` · `INS-PAR-08` · `VAL-ANA-01`
<!-- /usado-em -->

- **Label Dev**: `email`
- **Tipo**: texto
- **Validação**: formato de e-mail válido (`local@dominio.tld`).
- **Em aberto (por feature)**: obrigatoriedade; unicidade.
- **Mensagem**: "E-mail inválido."

```gherkin
# ── Validação de campo: E-mail ───────────────────────────────────
Scenario: E-mail em formato inválido
  Given que informo um e-mail sem "@" ou sem domínio
  When tento salvar
  Then o sistema rejeita e exibe "E-mail inválido."
```

### Senha
<!-- usado-em:gerado -->
> **Usado em:** _(ainda não referenciado em N3)_
<!-- /usado-em -->

- **Label Dev**: `senha`
- **Tipo**: texto (armazenado com hash — nunca em texto puro)
- **Validação**: política mínima (ex.: 8+ caracteres, com letra e número). Defina os parâmetros no MASTER/NFR de segurança.
- **Em aberto (por feature)**: política exata; confirmação de senha.
- **Mensagem**: "A senha não atende aos requisitos de segurança."

```gherkin
# ── Validação de campo: Senha ────────────────────────────────────
Scenario: Senha abaixo da política mínima
  Given que informo uma senha que não atende à política
  When tento salvar
  Then o sistema rejeita e exibe "A senha não atende aos requisitos de segurança."
```

### Valor monetário
<!-- usado-em:gerado -->
> **Usado em:** _(ainda não referenciado em N3)_
<!-- /usado-em -->

- **Label Dev**: `valor`
- **Tipo**: decimal (2 casas)
- **Validação**: ≥ 0; no máximo 2 casas decimais.
- **Em aberto (por feature)**: limite máximo; se aceita zero.
- **Mensagem**: "Informe um valor válido."

```gherkin
# ── Validação de campo: Valor monetário ──────────────────────────
Scenario: Valor negativo
  Given que informo um valor menor que zero
  When tento salvar
  Then o sistema rejeita e exibe "Informe um valor válido."
```

### CNPJ
<!-- usado-em:gerado -->
> **Usado em:** _(ainda não referenciado em N3)_
<!-- /usado-em -->

- **Label Dev**: `cnpj`
- **Tipo**: texto (14 dígitos, sem máscara no armazenamento)
- **Validação**: exatamente 14 dígitos numéricos; dígitos verificadores válidos.
- **Em aberto (por feature)**: obrigatoriedade; unicidade.
- **Mensagem**: "CNPJ inválido." ⚠️ *(proposta na regeneração 4.1.0, no padrão da mensagem do CPF — confirmar com o PO)*

```gherkin
# ── Validação de campo: CNPJ ─────────────────────────────────────
Scenario: CNPJ com dígitos verificadores inválidos
  Given que informo um CNPJ com dígito verificador incorreto
  When tento salvar
  Then o sistema rejeita e exibe "CNPJ inválido."
```

### Telefone
<!-- usado-em:gerado -->
> **Usado em:** `INS-PAR-02` · `VAL-ANA-01`
<!-- /usado-em -->

- **Label Dev**: `telefone`
- **Tipo**: texto
- **Validação**: DDD + número no formato nacional.
- **Em aberto (por feature)**: obrigatoriedade; se aceita fixo e celular.
- **Mensagem**: "Telefone inválido." ⚠️ *(proposta na regeneração 4.1.0 — confirmar com o PO)*

```gherkin
# ── Validação de campo: Telefone ─────────────────────────────────
Scenario: Telefone fora do formato nacional
  Given que informo um telefone sem DDD
  When tento salvar
  Then o sistema rejeita e exibe "Telefone inválido."
```

### Nome de pessoa
<!-- usado-em:gerado -->
> **Usado em:** `INS-PAR-01` · `INS-PAR-02` · `INS-PAR-08`
<!-- /usado-em -->

- **Label Dev**: `nomeCompleto`
- **Tipo**: texto
- **Validação**: nome e sobrenome; comprimento mínimo.
- **Em aberto (por feature)**: obrigatoriedade; comprimento mínimo e máximo.
- **Mensagem**: "Informe o nome completo." ⚠️ *(proposta na regeneração 4.1.0 — confirmar com o PO)*

```gherkin
# ── Validação de campo: Nome de pessoa ───────────────────────────
Scenario: Nome sem sobrenome
  Given que informo apenas o primeiro nome
  When tento salvar
  Then o sistema rejeita e exibe "Informe o nome completo."
```

### URL
<!-- usado-em:gerado -->
> **Usado em:** `CFG-MOD-02` · `CFG-MOD-03` · `CFG-VIN-04` · `CFG-VIN-06` · `CFG-VIN-09` · `CFG-VIN-10`
<!-- /usado-em -->

- **Label Dev**: `url`
- **Tipo**: texto
- **Validação**: formato de URL válido (http/https).
- **Em aberto (por feature)**: obrigatoriedade; tamanho máximo.
- **Mensagem**: "Informe um endereço válido, iniciado por http:// ou https://." ⚠️ *(proposta na regeneração 4.1.0 — confirmar com o PO)*

```gherkin
# ── Validação de campo: URL ──────────────────────────────────────
Scenario: Endereço sem protocolo
  Given que informo um endereço sem http:// nem https://
  When tento salvar
  Then o sistema rejeita e exibe "Informe um endereço válido, iniciado por http:// ou https://."
```

---

## Como adicionar um campo canônico

Um campo vira canônico quando aparece, com a **mesma semântica de validação**, em **2+ features**. Para promovê-lo:

1. Adicione uma linha ao **Índice** (Label PO, Label Dev, Tipo, resumo).
2. Crie a **entrada** completa (validação, parâmetros em aberto, mensagem, cenários).
3. Nos N3 que já tratavam o campo inline, substitua a definição por `→ ver FIELD-DICTIONARY: [nome]` e importe os cenários com o marcador.

---

## Instrução para a LLM

Ao especificar campos em um N3 (PROMPT_3A/3B):
1. Verifique se o campo é canônico — se for, **não pergunte** sobre suas validações; aplique automaticamente e pergunte apenas obrigatoriedade/unicidade.
2. Na tabela de campos, referencie `→ ver FIELD-DICTIONARY: [nome]`.
3. Nos cenários, importe com `# ← FIELD-DICTIONARY: [nome]` — não reescreva os cenários daqui.
4. Campo recorrente ainda não dicionarizado: proponha com ⚠️ e aguarde aprovação antes de promovê-lo.

> **Usado em (não escreva à mão)**: abaixo de cada `### <entrada>` há um bloco
> `> **Usado em:** …` entre `<!-- usado-em:gerado -->` e `<!-- /usado-em -->`,
> **gerado** por `scripts/generate-usage-index.mjs` a partir das referências
> `→ ver`/`←` dos N3. Não edite esse bloco à mão — rode o gerador (o CI valida
> que está fresco).
