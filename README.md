# Gob

Gob waa luuqad barnaamijeed oo kudhisan Java. Mashruucan waxaa ku jira
interpreter-ka Gob iyo class lagu abuuro `GenerateAst.java` class-yada kaladuwan ee AST-gu uu taageero (`Expr.java` iyo `Stmt.java`).

## Waxyaabaha loo baahan yahay

Hubi in kombiyuutarkaaga ay kugu jiraan:

- Java Development Kit (JDK) 17
- Apache Maven
- Git

Waxaad ku xaqiijin kartaa rakibidda:

```bash
java --version
javac --version
mvn --version
```

Saddexda amarba waa inay muujiyaan in Java 17 la isticmaalayo. Haddii Maven uu
soo saaro qaladka `invalid target release: 17`, hubi in `JAVA_HOME` uu ku
jeedo JDK 17.

## Soo dejinta mashruuca

```bash
git clone <cinwaanka-repository-ga>
cd gob-bare
```

## Abuurista AST-ga

Si aad dib ugu abuurto `Expr.java` iyo `Stmt.java`, gal galka Java-ga:

```bash
cd src/main/java

javac com/kq/gob/tools/GenerateAst.java
java com.kq.gob.tools.GenerateAst com/kq/gob/Gob

cd ../../..
```

Qalabkani wuxuu wax ka beddelayaa faylashan:

```text
src/main/java/com/kq/gob/Gob/Expr.java
src/main/java/com/kq/gob/Gob/Stmt.java
```

## Dhisidda mashruuca

Adigoo jooga galka ugu sarreeya ee mashruuca, orod:

```bash
mvn clean package
```

Marka dhismuhu guulaysto, Maven wuxuu abuuraa:

```text
target/gob-0.0.1.jar
```

## Orodsiinta Gob

Si aad u aragto caawimada:

```bash
java -jar target/gob-0.0.1.jar --caawi
```

Si aad u furto goobta aad si toos ah ugu qori karto koodhka Gob:

```bash
java -jar target/gob-0.0.1.jar --qor
```

Ama isticmaal magaca gaaban:

```bash
java -jar target/gob-0.0.1.jar -q
```

Si aad u orodsiiso fayl Gob ah:

```bash
java -jar target/gob-0.0.1.jar --file waddada/faylka.gob
```

Ama:

```bash
java -jar target/gob-0.0.1.jar -f waddada/faylka.gob
```

## Tijaabooyinka

Si aad u fuliso dhammaan tijaabooyinka:

```bash
mvn test
```

## Qaabka mashruuca

```text
src/main/java/com/kq/gob/Gob/    Interpreter-ka iyo qaybaha luuqadda
src/main/java/com/kq/gob/tools/  Qalabka abuura AST-ga
src/test/java/                   Tijaabooyinka mashruuca
pom.xml                          Dejinta Maven
```

## Ruqsadda

Mashruucan wuxuu ku shaqeeyaa License-ka ku xusan [LICENSE](LICENSE).
