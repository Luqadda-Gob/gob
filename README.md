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
git clone https://github.com/Luqadda-Gob/gob.git
cd gob
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

## Native executable-yada iyo Windows installer-ka

GitHub Actions wuxuu si gaar ah ugu dhisaa Gob Windows iyo Linux. Linux binary
laguma dhisi karo Windows, Windows `.exe`-gana laguma dhisi karo Linux.

Si aad u dhisto faylasha adigoon samayn release:

1. Fur qaybta **Actions** ee GitHub.
2. Dooro workflow-ga **Native release**.
3. Riix **Run workflow**.
4. Marka workflow-gu dhammaado, kasoo deji faylasha qaybta **Artifacts**.

Workflow-gu wuxuu abuuraa:

```text
gob-linux-x64.tar.gz
gob-windows-x64.zip
gob-0.0.1-windows-setup.exe
```

Windows setup-ku waa wizard ku rakiba `gob.exe`, wuxuu abuuri karaa desktop
shortcut, wuxuuna `.gob` faylasha ku xiri karaa Gob.

Si aad faylashan ugu daabacdo GitHub Release, marka hore hubi in nooca ku jira
`pom.xml` uu sax yahay. Kadib samee oo dir tag:

```bash
git tag v0.0.1
git push origin v0.0.1
```

Workflow-gu wuxuu si toos ah u abuuraa GitHub Release-ka iyo faylasha lagu soo
dejisan karo.

Si aad native executable ugu dhisto kombiyuutarkaaga, rakib GraalVM JDK 21 iyo
`native-image`, kadibna orod:

```bash
mvn clean package
native-image --no-fallback -jar target/gob-0.0.1.jar -o gob
```

Windows wuxuu abuuraa `gob.exe`, Linux-na wuxuu abuuraa `gob`.

Si aad Windows setup wizard-ka ugu dhisto kombiyuutarkaaga, rakib Inno Setup.
Kadib PowerShell-ka ku orod:

```powershell
New-Item -ItemType Directory -Force target/native
native-image --no-fallback -jar target/gob-0.0.1.jar -o target/native/gob
& "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe" installer/windows/gob.iss
```

Setup-ka la abuuray wuxuu galayaa `target/installer`.

## Qaabka mashruuca

```text
src/main/java/com/kq/gob/Gob/    Interpreter-ka iyo qaybaha luuqadda
src/main/java/com/kq/gob/tools/  Qalabka abuura AST-ga
src/test/java/                   Tijaabooyinka mashruuca
pom.xml                          Dejinta Maven
```

## Ruqsadda

Mashruucan wuxuu ku shaqeeyaa License-ka ku xusan [LICENSE](LICENSE).
