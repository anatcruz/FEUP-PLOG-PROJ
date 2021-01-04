# Crypto Product

## PLOG_TP2_T6_Crypto-Product_2
| Nome             | Número    | E-Mail               |
| ---------------- | --------- | ---------------------|
| Ana Teresa Feliciano da Cruz  | 201806460 | up201806460@fe.up.pt |
| André Filipe Meireles do Nascimento | 201806461 | up201806461@fe.up.pt |

---

## Instruções de execução

Executar SICStus, clicar em _File_, depois _Compile_, e finalmente selecionar o ficheiro `cp.pl` localizado na pasta do projeto.

O utilizador pode:

- Utilizar o predicado `showPuzzleSolutions(+LeftNumberVars, +RightNumberVars, +ResultVars)` para mostrar as soluções do puzzle na configuração passada. Por exemplo,  `showPuzzleSolutions([R], [B,G], [G,B,R]).` gera um puzzle R x BG = GBR.

- Utilizar o predicado `showPuzzlesAndSolutions(+LeftNumberDigits, +RightNumberDigits, -LeftNumber, -RightNumber, -ResultNumber)` para gerar puzzles, cujos números de digitos dos operandos são passados, e visualizar as respetivas soluções. Por exemplo, `showPuzzlesAndSolutions(1, 3, LeftNumber, RightNumber, Result).` gera puzzles de 1 digitos vezes 3 digitos e as respetivas soluções.

- Após definir o _Working directory_, utilizar o predicado `save(+LeftNumberDigits, +RightNumberDigits)` que gera todos os puzzles com a configuração de número de digitos de operandos passada e todas as respetivas soluções, e guarda os resultados no respetivo ficheiro. Pode também utilizar o predicado `save(+LeftNumberDigits, +RightNumberDigits, +Opt, +Opt2, +Opt3)` cujo objetivo é idêntico ao predicado anterior mas permite passar as opções de labeling a utilizar.