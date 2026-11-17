# Lab 10 — Өгөгдлийн урсгалын тест: Definition–Use хосууд

- Оюутны нэр: Азтүшиг
- Оюутны код: B232270014
- Starter эх код: `DataFlowTargets.java`
- Java version: java version "23.0.2" 2025-01-21
Java(TM) SE Runtime Environment (build 23.0.2+7-58)
Java HotSpot(TM) 64-Bit Server VM (build 23.0.2+7-58, mixed mode, sharing)
- mvn version: Apache Maven 3.9.9 (8e8579a9e76f7d015ee5ec7bfcdc97d260186937)
Maven home: C:\apache-maven-3.9.9
Java version: 23.0.2, vendor: Oracle Corporation, runtime: C:\jdk-23.0.2
Default locale: en_US, platform encoding: UTF-8
OS name: "windows 11", version: "10.0", arch: "amd64", family: "windows"

## А хэсэг — `gcd(x, y)`

Мөрийн дугаар нь starter файлын дугаарлалт. `p-use`-ийн T/F ирмэгийг тусдаа use гэж үзэв.

| Хувьсагч | Def мөр | Use мөр | Төрөл | Def-clear зам | Тестийн ID |
| --- | ---: | ---: | --- | --- | --- |
| x | 13 | 16 | c-use | 13 → 15(T) → 16 | `gcd_12_8...` |
| x | 13 | 20 | c-use | 13 → 15(F) → 20 | `gcd_7_0...` |
| x | 17 | 16 | c-use | 17 → 15(T) → 16 | `gcd_12_8...` (дараагийн давталт) |
| x | 17 | 20 | c-use | 17 → 15(F) → 20 | `gcd_12_8...` |
| y | 13 | 15(T) | p-use | 13 → 15(T) | `gcd_12_8...` |
| y | 13 | 15(F) | p-use | 13 → 15(F) | `gcd_7_0...` |
| y | 13 | 16 | c-use | 13 → 15(T) → 16 | `gcd_12_8...` |
| y | 13 | 17 | c-use | 13 → 15(T) → 16 → 17 | `gcd_12_8...` |
| y | 18 | 15(T) | p-use | 18 → 15(T) | `gcd_12_8...` (эхний давталтын дараа) |
| y | 18 | 15(F) | p-use | 18 → 15(F) | `gcd_12_8...` (сүүлийн давталтын дараа) |
| y | 18 | 16 | c-use | 18 → 15(T) → 16 | `gcd_12_8...` (дараагийн давталт) |
| y | 18 | 17 | c-use | 18 → 15(T) → 16 → 17 | `gcd_12_8...` (дараагийн давталт) |
| tmp | 16 | 18 | c-use | 16 → 17 → 18 | `gcd_12_8...` |

**Тайлбар.** `gcd(7,0)` нь давталт огт хийхгүй. Тиймээс `x`-ийн 13-р мөрийн def-ээс 20-р мөрийн return use хүртэлх хос, `y`-ийн 13-р мөрийн def-ээс 15-р мөрийн F p-use хүртэлх хосыг хамарна. `gcd(12,8)` нь хоёр удаа давтана: (12,8) → (8,4) → (4,0). Хоёр дахь давталт нь 17-р мөрийн `x` def-ээс 16/20-р мөрийн use, эхний давталтын 18-р мөрийн `y` def-ээс дараагийн 15/16/17-р мөрийн use, `tmp`-ийн 16→18 хосыг хамруулахад шаардлагатай.

`tmp` нь 14-р мөрөнд зөвхөн зарлагдсан бөгөөд утга оноогоогүй. Иймээс 14-р мөр нь def биш; зөвхөн 16-р мөрийн assignment def болно.

## B хэсэг — `bonus(attendance, threshold)`

### B1. CFG

`cfg-bonus.png` нь мөрийн дугаартай CFG. For-each-ийн 38-р мөрийн шийдвэрийг `attendance`-д дараагийн элемент байгаа эсэх p-use, давталтын бие рүү орох ирмэгийг T, дуусах ирмэгийг F гэж загварчилсан. `a` хувьсагчийн def нь дараагийн элементийг оноох алхам дээр үүснэ.

### B2. Def/Use жагсаалт

| Мөр | Definition (def) | Use (c-use / p-use) |
| ---: | --- | --- |
| 31 | `attendance`, `threshold` параметрийн эхний def | — |
| 32 | — | `attendance == null` (p-use); short-circuit-ийн дараа `threshold < 0` (p-use) |
| 35 | `present = 0` | — |
| 36 | `streak = 0` | — |
| 37 | `best = 0` | — |
| 38 | `a` (for-each-ийн iteration бүрт шинэ def) | `attendance`-ийн дараагийн элемент байгаа эсэх (p-use) |
| 39 | — | `a > 0` (p-use) |
| 40 | `present = present + 1` | `present` (c-use) |
| 41 | `streak = streak + 1` | `streak` (c-use) |
| 42 | — | `streak > best`: `streak`, `best` хоёулаа p-use |
| 43 | `best = streak` | `streak` (c-use) |
| 46 | `streak = 0` | — |
| 49 | `score = 0` | — |
| 50 | — | `present >= threshold`: `present`, `threshold` хоёулаа p-use |
| 51 | `score = 5` | — |
| 53 | — | `best >= 5` (p-use) |
| 54 | `score = score + 3` | `score` (c-use) |
| 56 | — | `score` (c-use) |

### B3. DU хосууд ба kill

Хүснэгтэд def-clear замтай хосуудыг оруулав. T/F p-use-ийг тусад нь бичсэн. Давталтын олон iteration-д үүсэх ижил хэлбэрийн хосыг нэг мөрөөр төлөөлүүлэв.

| Хувьсагч | Def → Use | Төрөл | Def-clear зам / Тайлбар | Тестийн ID |
| --- | --- | --- | --- | --- |
| attendance | 31 → 32(T) | p-use | attendance null; threshold-ийн шалгалт short-circuit болно | `duPairs_10` |
| attendance | 31 → 32(F) | p-use | attendance null биш | `allDefs_01` |
| attendance | 31 → 38(T) | p-use | массивт дор хаяж нэг элемент бий | `allDefs_01` |
| attendance | 31 → 38(F) | p-use | хоосон массив / бүх элемент дууссан | `duPairs_03` |
| threshold | 31 → 32(T) | p-use | массив null биш, threshold сөрөг | `duPairs_11` |
| threshold | 31 → 32(F) | p-use | массив null биш, threshold 0 буюу эерэг | `allDefs_01` |
| threshold | 31 → 50(T) | p-use | `present >= threshold` | `duPairs_03`, `duPairs_05` |
| threshold | 31 → 50(F) | p-use | `present < threshold` | `allDefs_01`, `duPairs_08` |
| a | 38 → 39(T) | p-use | тухайн өдөр ирсэн (`a > 0`) | `allDefs_01` |
| a | 38 → 39(F) | p-use | тухайн өдөр тасалсан (`a <= 0`) | `allDefs_01` |
| present | 35 → 40 | c-use | эхний ирсэн өдөр нэмэгдүүлэхийн өмнөх утга | `allDefs_01` |
| present | 35 → 50(T) | p-use | ирцийн элементгүй, threshold=0 | `duPairs_03` |
| present | 35 → 50(F) | p-use | ирцийн элементгүй, threshold>0 | `duPairs_04` |
| present | 40 → 40 | c-use | дараагийн ирсэн өдөр өмнөх тоог ашиглана | `allDefs_02` |
| present | 40 → 50(T) | p-use | эцсийн ирц threshold-д хүрсэн | `duPairs_05` |
| present | 40 → 50(F) | p-use | эцсийн ирц threshold-д хүрээгүй | `allDefs_01`, `duPairs_08` |
| streak | 36 → 41 | c-use | эхний эерэг элементийн өмнөх streak=0 | `allDefs_01` |
| streak | 41 → 41 | c-use | дараалсан эерэг элементийн өмнөх streak | `allDefs_02` |
| streak | 41 → 42(T) | p-use | streak best-ээс их | `allDefs_02` |
| streak | 41 → 42(F) | p-use | reset-ийн дараах богино streak best-ээс их биш | `duPairs_09` |
| streak | 41 → 43 | c-use | 42-р мөрийн T салаагаар best шинэчлэх RHS | `allDefs_02` |
| streak | 46 → 41 | c-use | тасалдлын дараа дараагийн өдөр ирэхэд 0-ээс нэмэгдүүлэх | `allDefs_01`, `duPairs_06` |
| best | 37 → 42(T) | p-use | хамгийн эхний streak=1 нь best=0-ээс их | `allDefs_01` |
| best | 43 → 42(T) | p-use | шинэ streak өмнөх best-ээс урт | `allDefs_02` |
| best | 43 → 42(F) | p-use | дараах streak өмнөх best-ээс урт биш | `duPairs_09` |
| best | 37 → 53(F) | p-use | ирсэн өдөр огт байхгүй тул best=0 | `duPairs_03`, `duPairs_04` |
| best | 43 → 53(T) | p-use | best streak 5 буюу түүнээс урт | `allDefs_02`, `duPairs_08` |
| best | 43 → 53(F) | p-use | best streak 5-аас бага | `allDefs_01`, `duPairs_05` |
| score | 49 → 54 | c-use | present босго хүрэхгүй, best>=5 тул +3 нэмнэ | `duPairs_08` |
| score | 49 → 56 | c-use | present босго хүрэхгүй, best<5 тул шууд буцаана | `allDefs_01` |
| score | 51 → 54 | c-use | 5 оноон дээр 3 нэмэх | `allDefs_02` |
| score | 51 → 56 | c-use | 5 оноо авсан ч best<5 | `duPairs_05` |
| score | 54 → 56 | c-use | нэмэгдүүлсэн оноог буцаах | `allDefs_02`, `duPairs_08` |

**Kill-ийн тайлбар.** 46-р мөрийн `streak = 0` нь өмнөх 41-р мөрийн `streak` def-ийг kill хийж, түүний дараах def-clear замыг тасална. Харин 46-р мөр өөрөө шинэ def үүсгэнэ. Дараагийн эерэг элемент дээр 41-р мөрийн `streak = streak + 1` RHS нь 46-р мөрийн def-ийг ашиглаад, дараа нь шинэ def үүсгэнэ. Иймээс 46→41 c-use хос боломжтой; 46→42/43 шууд хос боломжгүй (41-р мөр эхэлж дахин тодорхойлно).

**Def-clear замгүй / биелэшгүй хосууд.** 36→42, 36→43 хос боломжгүй: 42/43 хүрэхийн өмнө 41-р мөр streak-ийг дахин тодорхойлно. 46→42, 46→43 мөн адил 41-р мөрөөр kill хийгдэнэ. 37→42(F) биелэшгүй: эхний эерэг элемент дээр streak=1, best=0 тул нөхцөл заавал үнэн; харин дараагийн харьцуулалтад best аль хэдийн 43-р мөрөөр шинэчлэгдсэн байна. 37→53(T) биелэшгүй: best анхны 0 утгаараа 5 хүрэх боломжгүй; эерэг өдөр бүр 42(T) → 43-р мөрөөр best шинэчлэгдэнэ. 49→51 шууд DU хос биш: 49-р мөрийн score def-ийг 51-р мөрийн def kill хийнэ, 51 нь use биш def.

### B4. All-defs ба all-DU-pairs тестийн үндэслэл

**All-defs шатанд хамгийн багадаа 2 тест шаардлагатай.** `score=0` (49-р мөр) def-ийг use-д хүргэхийн тулд `present >= threshold` нөхцөл худал байх ёстой; харин `score=5` (51-р мөр) def-ийг гаргахын тулд тэр нөхцөл үнэн байх ёстой. Нэг гүйцэтгэлд 51-р мөр биелбэл 49-р мөрийн def-ийг kill хийнэ. Тиймээс эдгээр хоёр score def-ийг хоёуланг нь use-д хүргэхийн тулд тусдаа хоёр гүйцэтгэл зайлшгүй.

1. `allDefs_01_reset_streak_and_score_zero_definition`: `[1,0,1]`, threshold=4. Энэ нь score=0 def-ийг 56-д хүргэж, 35/36/37-ын эхний def, 40/41/46-ын update/reset def-үүдийг use-д хүргэнэ.
2. `allDefs_02_five_consecutive_days_score_five_then_eight`: `[1,1,1,1,1]`, threshold=5. Энэ нь score=5 def-ийг 54-д ашиглаж, score=8 def-ийг 56-д хүргэнэ; давталтын present/streak/best def-үүдийг ч хамруулна.

All-DU-pairs шатанд дараах тестүүд нэмэгдсэн: хоосон массив/threshold=0, бүгд тасалсан, яг threshold, тасалдлын дараах 5 дараалсан өдөр, нийт ирц ба хамгийн урт streak-ийн ялгаа, best>=5 боловч present<threshold, streak>best-ийн F салаа, null болон сөрөг threshold-ийн exception.

### B5. JaCoCo ба DU хамралтын ялгаа

JaCoCo branch coverage нь нөхцөл бүрийн T/F салаа гүйцэтгэгдсэн эсэхийг харуулна. Энэ нь def-ээс тодорхой use хүртэлх def-clear замын бүх хосыг хэмжихгүй. Жишээлбэл `streak`-ийн 46-р мөрийн reset def-ээс 41-р мөрийн дараагийн RHS use хүртэлх хосыг branch бүрэн хамарсан байсан ч тусгайлан гүйцэтгээгүй байж болно. All-defs нь def бүрийг дор хаяж нэг use-д хүргэх боловч def бүрийн бүх use-ийг шалгахгүй.

## C хэсэг — Fault seeding

Мутаци бүрийг `DataFlowTargets.java` дээр нэг нэгээр нь хийнэ. Тест дуусмагц `git restore src/main/java/mn/edu/must/sqat/DataFlowTargets.java` гэж эх кодыг сэргээнэ. Мутацийг commit хийхгүй.

| Мутаци | Тестийн хүлээгдэх үр дүн | Шалтгаан |
| --- | --- | --- |
| M1 — 41-р мөрийн `streak = streak + 1`-ийг устгах | `allDefs_02...`, `duPairs_06...`, `duPairs_08...` унах ёстой | Manual runner: `allDefs_02` expected 8, was 5; `duPairs_06` expected 8, was 5; `duPairs_08` expected 3, was 0. |
| M2 — 43-р мөрийн `best = streak`-ийг `best = present` болгох | `duPairs_07...` унах ёстой | `[1,1,0,1,1,0,1,1,1]` үед present=7, best streak=3. Сүүлийн streak 3 болох үед `3 > өмнөх best 2` тул мутацийн `best = present` нь best=7 болгож буруу +3 оноо өгнө. Manual runner: expected 5, was 8. |
| M3 — давталтын дараа ашиглагдахгүй `int total = present + best;` нэмэх | Тестүүд унахгүй | Manual runner: 13 тест, 0 failure. Dead definition нь гаралтад нөлөөлөхгүй. IDE/static analysis-ийн unused local variable анхааруулга илрүүлэх ёстой; `javac` заавал алдаа өгөхгүй. |

Энэ тестийн багцад M2 амьд үлдэхгүй: `duPairs_07_total_present_exceeds_best_streak_kills_wrong_best_update` нь нийт ирц ба хамгийн урт дараалсан streak өөр байгааг зориуд сонгосон тул буруу хувьсагчийн хэрэглээг илрүүлнэ. M3-ийн IDE анхааруулгын яг текстийг ашигласан IDE-ээсээ хуулж хавсаргах шаардлагатай.

## Дүгнэлт (6–8 өгүүлбэр)

DU анализ нь branch coverage-ээс илүү нарийн түвшинд хувьсагчийн тодорхойлолт ба хэрэглээний холбоог шалгадаг. Branch coverage 100% болсон ч тодорхой def-ээс тодорхой use хүртэлх def-clear зам тестлэгдээгүй үлдэж болно. All-defs нь def бүрийг дор хаяж нэг use-д хүргэдэг боловч бүх DU хосыг хамруулахгүй. All-DU-pairs нь илүү бүрэн шалгалт өгдөг ч CFG байгуулах, def/use цэгүүдийг ялгах, kill-ээр тасарсан замыг шинжлэхэд их цаг шаарддаг. Fault seeding нь тестийн багц зориуд тарьсан бодит гажилтыг илрүүлж чадаж байгаа эсэхийг шалгана. M1 нь streak update-ийг алга болгосон тул `allDefs_02`, `duPairs_06`, `duPairs_08` тестээр баригдана. M2 нь нийт ирц ба хамгийн урт streak-ийг андуурсан тул ялгаатай утгатай өгөгдөл шаарддаг. M3 нь үр дүнд нөлөөлөхгүй dead definition учраас IDE/static analysis-аар илрүүлэх ёстой.

## AI туслах ашигласан тухай

AI туслахыг хүснэгтийн ноорог гаргахад туслуулсан, DU хосын хүснэгтийг гаргуулсан.

## Бэлтгэл орчинд бодитоор ажиллуулсан шалгалт

`results/manual-javac-check.txt` — starter production class-ийг `javac`-аар compile хийж, 11 үндсэн жишээний expected/actual утгыг Java harness-аар шалгасан гаралт. `results/manual-mutation-check.txt` — M1, M2, M3-ийг түр өөрчилж `javac/java`-аар үр нөлөөг шалгасан гаралт. `results/manual-test-runner.txt` болон `results/manual-mutation-test-runner.txt` нь түр JUnit API stub ашиглан тестийн эх кодыг ажиллуулсан шалгалт; албан ёсны JUnit/Surefire/JaCoCo-ийн үр дүн биш. Maven суулгагдаагүй тул шаардлагатай Maven лог болон JaCoCo CSV-үүдийг өөрийн Maven орчинд `run-alldefs.sh`, `run-lab.sh` скриптээр үүсгэж нэмэх шаардлагатай.

## Нэмэлт даалгавар(AI өнцөг, заавал биш)

AI-ийн DU хүснэгт ба өөрийн шинжилгээний харьцуулалт

AI туслахын гаргасан DU хүснэгтийг DataFlowTargets.java эх кодтой мөр мөрөөр тулган шалгахад present, streak, best, score, attendance, threshold, a хувьсагчдын ихэнх definition-use хосыг зөв тодорхойлсон. Гэхдээ AI-ийн хүснэгтэд зарим хосын тестийн ID болон def-clear замын тайлбар бүрэн нарийвчлалтай биш байсан эдгээрийг эх кодын гүйцэтгэлийн дараалалтай тулган засах шаардлагатай байсан. Ялангуяа 46-р мөрийн streak=0 нь өмнөх streak-ийн тодорхойлолтыг kill хийдэг боловч өөрөө шинэ definition үүсгэдэг. Энэ шинэ тодорхойлолт дараагийн iteration-ийн 41-р мөрийн streak=streak+1 үйлдэлд ашиглагдах боломжтой, харин 42 болон 43-р мөрөнд шууд хүрэх боломжгүй, учир нь 41-р мөрөнд дахин тодорхойлогдоно. Мөн 37-р мөрийн best=0 тодорхойлолтоос 42-р мөрийн худал салаа руу хүрэх хос биелэх боломжгүй: эхний эерэг ирцийн үед streak=1, best=0 тул нөхцөл заавал үнэн болно. Үүнтэй адил 37-р мөрийн анхны best тодорхойлолтоос 53-р мөрийн үнэн салаа руу хүрэх боломжгүй, учир нь best-ийн утга 5 хүрэхийн тулд 43-р мөрөөр шинэчлэгдсэн байх шаардлагатай. AI-ийн хүснэгтэд def-clear замаар kill хийгдсэн хосуудыг ялгах зарчим зөв байсан боловч зарим боломжгүй хосыг илүү тодорхой үндэслэх шаардлагатай байсан. Эцэст нь би эх кодын бодит гүйцэтгэлийн дараалал, хувьсагчийн дахин тодорхойлолт болон kill нөхцөлийг үндэслэн хосуудыг шалгаж, def-clear замгүй эсвэл биелэх боломжгүй хосуудыг DU хамралтад тооцохгүй байх нь зөв гэж дүгнэсэн.
