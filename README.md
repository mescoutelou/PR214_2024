# PR214_2024

## Installation des outils

```
source install-local.sh
```

```
source setup.sh
```

## Développement et simulation

```
sbt "runMain prj.example.Example --o=output"
```

```
sbt test
```

```
sbt "testOnly prj.example.ExampleTest"
```

```
gtkwave Example_test_should_pass/Example.vcd
```

## Planning 

15 semaines

| Tâche                                                   | Durée (semaines) | Fin prévue | Fin réelle | Points |
| :------------------------------------------------------ | :--------------- | :--------- | :--------- | :----- |
| Début                                                   | 0                | 22/01/2024 | 22/01/2024 | 0      |
| Installation / Prise en main / Théorie                  | 3                | 12/02/2024 | XX/XX/2024 | 0      |
| Première version testée de chaque composant             | 4                | 11/03/2024 | XX/XX/2024 | 4      |
| Système global testé                                    | 2                | 25/03/2024 | XX/XX/2024 | 3      |
| Ajout d'une instruction par composant et test           | 2                | 08/04/2024 | XX/XX/2024 | 3      |
| Support de l'ensemble des instructions attendues        | 4                | 06/05/2024 | XX/XX/2024 | 5      |
| Soutenance                                              | X                | 07/05/2024 | 07/05/2024 | 4      |

## Règles de conception

- Utiliser des constantes avec des valeurs littérales dès que possible.
- Avant description par un langage, le fonctionnement de chaque bloc doit être descriptible sur papier.
- Une seule `Class` héritant de `Module` par fichier.
- Chaque `Class` héritant de `Module` doit être, autant que possible, clairement divisible en une partie combinatoire et des registres associés. 
- Afin de rendre le code plus clair et lisibles, les conventions de nommage suivantes doivent être respectées (aussi bien en **VHDL**/**Verilog**/**SystemVerilog**/**Chisel**):
  1. Uniquement des minuscules pour les noms de signaux et de registres.
  2. Uniquement des lettres et chiffres pour les noms de classes, le premier caractère étant une majuscule.
  3. Uniquement des majuscules pour les noms de constantes.
  4. Noms aussi courts et explicites que possible.
  5. Chaque nom de signal ou bus en entrée (`Input()`) commence par le préfixe *i_*.
  6. Chaque nom de signal ou bus en sortie (`Output()`) commence par le préfixe *o_*.
  7. Chaque nom de groupe de signaux avec des entrées ET des sorties commence par le préfixe *b_*.
  8. Chaque nom de registre (`Reg()`/`RegInit()`) commence par le préfixe *r_*.
  9. Chaque nom de module (`Module()`) commence par le préfixe *m_*.
- Commenter le code de manière pertinente (une phrase explicative pour plusieurs lignes réalisant une tâche précise, ou une ligne avec une fonction particulière *etc.*).
