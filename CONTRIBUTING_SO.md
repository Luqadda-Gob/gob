# Wax ku biirinta Gob

[English](CONTRIBUTING.md) | [Soomaali](CONTRIBUTING_SO.md)

Waad ku mahadsan tahay inaad wax ku biirinayso Gob. Gob waa luuqad barnaamijeed
oo ku dhisan Java. Waxaad wax ku biirin kartaa interpreter-ka, qaabka
luuqadda, qoraallada hagista, tijaabooyinka, qalabka, iyo diyaarinta noocyada
la sii daayo.

## Kahor intaadan bilaabin

- Raadi issues-ka iyo pull requests-ka jira kahor intaadan shaqada bilaabin.
- Fur issue kahor intaadan samayn isbeddel weyn ama beddelin hab-dhaqanka
  luuqadda.
- Pull request kasta diiradda waa inoo saara hal khalad ama hal shay.
- Ha soo dalicin faylasha IDE-ga, ama faylasha `.class`.

Markaad wax ku biiriso mashruuca, waxaad oggolaanaysaa in wax-ku-biirintaada
lagu bixiyo Apache License 2.0 ee mashruucan lagu isticmaalo.

## Waxyaabaha loo baahan yahay

Hubi in kombiyuutarkaaga ay ku jiraan:

- Git
- Java Development Kit (JDK) 17 ama ka cusub
- Apache Maven

GraalVM khasab ma aha. Waxaa loo baahan yahay oo keliya marka laga shaqaynayo
samaynta executable-ka native-ka ah.

Waxaad ku xaqiijin kartaa rakibidda:

```bash
java --version
javac --version
mvn --version
```

## Soo dejinta mashruuca

Marka hore fork ka samee repository-ga, kadibna soo deji fork-gaaga:

```bash
git clone https://github.com/MAGACAAGA/gob.git
cd gob
```

U samee branch isbeddelkaaga:

```bash
git switch -c feature/sharaxaad-gaaban
```

Isticmaal magac branch oo si cad u sheegaya isbeddelka, sida
`fix/parser-error-reporting` ama `feature/list-methods`.

## Qaabka mashruuca

```text
src/main/java/com/kq/gob/Gob/    Interpreter-ka iyo qaybaha luuqadda
src/main/java/com/kq/gob/tools/  Qalabka abuura AST-ga
src/test/java/                   Tijaabooyinka mashruuca
pom.xml                          Dejinta Maven
```

Meesha ugu horraysa ee mashruucu ka bilaabmo waa:

```text
com.kq.gob.Gob.Gob
```

## Dhisidda iyo orodsiinta mashruuca

Adigoo jooga galka ugu sarreeya ee mashruuca, dhis mashruuca:

```bash
mvn clean package
```

Si aad u aragto caawimada:

```bash
java -jar target/gob-0.0.1.jar --caawi
```

Si aad u furto goobta aad si toos ah ugu qori karto koodhka Gob:

```bash
java -jar target/gob-0.0.1.jar --qor
```

Si aad u orodsiiso fayl Gob ah:

```bash
java -jar target/gob-0.0.1.jar --file waddada/barnaamijka.gob
```

## Tijaabooyinka

Kahor intaadan dirin pull request, fuli dhammaan tijaabooyinka:

```bash
mvn test
```

Markaad beddelayso hab-dhaqanka mashruuca, ku dar ama wax ka beddel
tijaabooyinka:

- Isbeddellada Scanner-ka geli `ScannerTest`.
- Isbeddellada Parser-ka geli `ParserTest`.
- Isbeddellada Interpreter-ka geli `InterpreterTest`.
- Hab-dhaqanka luuqadda oo dhan geli `IntegrationTest`.

Tijaabooyinku waa inay hubiyaan natiijada saxda ah iyo khaladaadka la xiriira.

## Abuurista AST-ga

`Expr.java` iyo `Stmt.java` waxaa abuura `GenerateAst.java`. Marka aad
beddelayso expression-yada ama statement-yada AST-gu taageero, wax ka beddel
qalabka abuura, kadibna dib u abuur labada fayl:

```bash
cd src/main/java
javac com/kq/gob/tools/GenerateAst.java
java com.kq.gob.tools.GenerateAst com/kq/gob/Gob
cd ../../..
```

Faylasha cusub ee `Expr.java` iyo `Stmt.java` la commit garee isbeddelka
`GenerateAst.java`. Kahor commit-ka, tirtir faylasha `.class` ee la abuuray.

## Habka qorista koodhka

- Raac qaabka Java-ga iyo qaabka galalka ee mashruucu hadda isticmaalo.
- Isticmaal magacyo cad oo la jaanqaadaya erayada interpreter-ku isticmaalo.
- Method kasta hal shaqo oo cad ha qabto, kana fogow isbeddello aan shaqadaada
  la xiriirin.
- Ilaali hab-dhaqanka luuqadda Gob haddii isbeddelku aanu ahayn mid ula kac ah
  oo la sharaxay.
- Comment ku dar keliya marka sababta koodhku aanay muuqan.
- Farriimaha Gob ee isticmaaluhu arko ha la jaanqaadaan kuwa mashruuca ku jira.

## Wax ku biirinta executable-ka native-ka ah

Taageerada executable-ka native-ka ah waa inay ahaato ikhtiyaari. JAR-ka
caadiga ah ee Maven waa inuu ku sii dhismi karaa kuna sii shaqayn karaa
OpenJDK-ga caadiga ah.

Ku dhis executable-ka Windows-ka kadib `mvn package`:

```powershell
$env:JAVA_HOME = "C:\Java\graalvm-jdk-21.0.11"   # wadada GraalVM-kaaga wax ka beddel
$env:PATH = "$env:JAVA_HOME\bin;$env:PATH"
New-Item -ItemType Directory -Force target/native
native-image --no-fallback -jar target/gob-0.0.1.jar -o target/native/gob
```

Haddii aad wax ka beddelayso samaynta GraalVM Native Image:

- Qor nooca GraalVM iyo qalabka operating system-ka ee loo baahan yahay.
- Hubi in `mvn test` iyo `mvn package` ay wali si caadi ah u shaqaynayaan.
- Ku tijaabi `gob.exe` Windows-ka, oo ay ku jirto laba-gujinta fayl `.gob` ah.
- Ha ku darin executable-yada la abuuray repository-ga.

Executable-yada native-ka ah waxay ku xiran yihiin operating system-ka.
Windows, Linux, iyo macOS mid kasta waa in si gaar ah loogu dhisaa.

## Commit-ka iyo pull request-ka

Kahor intaadan furin pull request:

```bash
mvn clean test
mvn package
git status
```

Pull request-kaagu waa inuu:

- Sharaxo khaladka ama baahida iyo xalka aad dooratay.
- Sheego isbeddel kasta oo isticmaalaha luuqaddu arki doono.
- Ku daro tijaabooyin hubinaya hab-dhaqanka la beddelay.
- Cusboonaysiiyo qoraallada hagista marka amar ama hab-dhaqan la beddelo.
- Ka fogaado habayn ama isbeddello kale oo aan shaqada la xiriirin.
- Xaqiijiyo in tijaabooyinka iyo dhisidda Maven ay guulaysteen.

Isticmaal farriimo commit oo gaaban oo cad. Tusaalooyin:

```text
Fix parser handling of missing semicolons
Add tests for function return values
Document native executable builds
```

## Soo gudbinta khaladaadka

Markaad soo gudbinayso khalad, ku dar:

- Koodhka Gob ee khaladka soo saaraya.
- Amarka aad ku orodsiisay.
- Natiijada aad filaysay.
- Natiijada dhacday iyo farriinta khaladka oo dhan.
- Operating system-kaaga, nooca Java, iyo nooca Maven.

Haddii khaladku la xiriirayo amniga, faahfaahinta sida khaladka looga faa'iidaysan
karo ha ku qorin issue dadweyne.
