# Introducción a Linux

Curso de Linux que impulsará mis habilidades de cara a ser Hacker Ético, siempre ético!

## Introducción

La idea de la academia es para todos los niveles de usuarios

### Sistemas operativos para pentesting

¿Qué es un sistema operativo?

Un sistema operativo es el conjunto de programas de un sistema informático que gestiona los recursos del hardware y provee servicios a los programas de aplicación de software.

* [Enlace de descarga de Parrot](https://parrotsec.org/download/)
* [Enlace de descarga de Kali Linux](https://www.kali.org/get-kali/)

### Creando una nueva máquina virtual

Para descargar VMWare Workstation a través del siguiente enlace:

* [VMWare](https://www.vmware.com/es/products/workstation-pro/workstation-pro-evaluation.html)

En cuanto a propiedades:

* SSD: 60GB
* RAM: 4GB
* Procesadores: 2
* Adaptador de red: Bridged

## Temario

### Comandos básicos de Linux [1-2]

* [Chuleta de comando linux](https://ciberninjas.com/chuleta-comandos-linux/)

* whoami: Comando para saber que usuario soy
* id: Comando para ver a que grupos pertenezco, es importante analizar en que grupo estoy, porque algun grupo puede presentar un riesgo potencial para una escalada de privilegios
* which: para ver la ruta de la herramienta-binario que estoy escribiendo

Los grupos los podemos ver en la ruta: /etc/group

La variable de entorno puede ser buscada con **echo $PATH**

Comandos vistos:

* ls
* cat, que está con alias hacia batcat
* grep, ligeramente visto

### Comandos básicos de Linux [2-2]

* [Comandos básicos de Linux](https://www.bonaval.com/kb/cheats-chuletas/comandos-basicos-linux)
* [Guía en PDF de comandos básicos de Linux](https://www.fing.edu.uy/inco/cursos/sistoper/recursosLaboratorio/tutorial0.pdf)

En caso de que el comando which no este, podemos hacer uso del comando **command -v whoami**

Comandos vistos:

1. cd -> Change Directory
2. commmand -v whoami -> comando que busca por la ruta como el which
3. cd .. -> regresamos un directorio
4. pwd -> print work directory, nos hace un echo de la ruta donde nos encontramos
5. ctrl + 1 -> limpiar terminal
6. cd -> siempre me va a llevar mi directorio home
7. echo $HOME -> Me va a mostrar cual es mi directorio home
8. echo $PATH -> Me muestra las variables de entorno
9. echo /etc/passwd -> Se definen los directorios personales de usuario
10. echo $SHELL -> Tipo de shell que estoy utilizando
11. cat /etc/shells -> tipos de shell existentes

### Control de flujo stderr-stdout, operadores y procesos en segundo plano

* [Redirectores en Bash, Formato PDF](https://hack4u.io/wp-content/uploads/2022/05/bash-redirections-cheat-sheet.pdf)

Esta parte es fundamental, sobre todo de cara a las clases de scripting en bash que tendremos más adelante, pues haremos mucho uso de estas.

Comandos vistos:

1. whoami; ls -> primero ejecuta el whoami y despues el ls, estamos haciendo concatenacion de comandos
2. whoami && ls -> AND, Se ejecuta el segundo comando solo si el primero devuelve un código de estado exitoso
3. echo $? -> Sí devuelve un cero en parrot el comando tiene un código de estado exitoso, si es 127 el código de estado no fue exitoso, dicho de otra manera el comando anterior no se ejecutó correctamente
4. whoam || ls -> OR, En caso de que el primer operando no sea correcto ejecutará el segundo operando.
5. wireshark & -> El amperson hasta el final indica que deseo abrir cualquier aplicación en segundo plano, me habilita un pid, pero sigo dependiendo de la terminal activa, ya que es un proceso hijo de esa instancia de terminal.
6. wireshark & disown -> Lo mismo que el comando anterior solo que aquí ya no depende de la terminal.

stderr -> standar error -> El error se define como stderr -> también se puede referenciar con el número 2

```bash
whoam 2>/dev/null # Quiero que me envies el error al dev/null, el dev/null es como un agujero negro, es un archivo especial, cualquier cosa que metamos ahi desaparece, el comando al ejecutarse y tener errores, no nos lo reportará en pantalla y todo los errores serán mandados al archivo antes mencionado
```

```bash
cat /etc/host 2>/dev/null # Quiero que me leas lo del directorio pasado y si no existe, el error de directorio no existente lo mandará al dev/null
```

stdout -> standar output -> La salida de los comandos

Forma rara

```bash
cat /etc/hosts > /dev/null # Hace que todo el flujo del programa se rediriga al dev/null, de tal manera que lo ejecutamos y no vemos nada, aunque todo es correcto.

cat /etc/host > /dev/null # Esto nos muestra el stderr

cat /etc/host > /dev/null 2>&1 # Convertimos el stderr en stdout
```

Forma más cómoda

```bash
cat /etc/host &>/dev/null # De esta forma tanto el stderr como el stdout no se mostrarán en pantalla
```

Cuando es útil no mostrar nada por pantalla, muestra ejemplo de wireshark reportando todo por consola ademas de la interfaz gráfica.

```bash
wireshark # Lanza la herramienta con la interfaz gráfica en primer plano y la CLI en segundo plano mandando stdout

wireshark &>/dev/null # Lanza la herramienta sin reportar nada por CLI

remmina &>/dev/null & disown # Lanza remmina sin reportar nada por CLI en segundo plano sin que dependa de la terminal, crea un PID
```

![Imagen de apoyo, misma que el enlace de arriba](/img/2.png)

### Descriptores de archivos

Comandos vistos:

```bash
exec 3<> file # Al dar al enter nos crea un archivo file
file file # Nos marca que esta vacio, file nos detecta el tipo de archivo en base a los magic numbers
# Hemos creado un descriptor de archivos identificado con el número 3
# Para comunicarme con el descriptor de archivos que tiene capacidad de lectura y escritura, < = lectura, > escritura
whoami >&3 # El output lo almacena en el descriptor de archivos 3 que tiene capacidad de escritura
cat file # Nos muestra la salida del comando whoami
# Al ir agregando más comandos, los irá apilando debajo
exec 3>&- # Para cerrar el descriptor de archivo
ls >&3
> zsh: 3: bad file descriptor

exec 8>&5 # Lo que hay en el 5 crea una copia al 8
exec 5>&- # Para cerrar el descriptor de archivos 5
exec 5<> example # Creamos descriptor de archivos con capacidad de lectura y escritura
whoami >&5 # Agregamos el output al descriptor 5
cat example # Leemos el descriptor
> root
exec 6>&5- # Creamos un descriptor de archivos 6 que es una copia del 5 pero cerramos el 5
```

### Lectura e interpretación de permisos [1-2]

[Permisos y derechos en Linux](https://blog.desdelinux.net/permisos-y-derechos-en-linux/?msclkid=22f8cb88ba8111ecb5d8a3db91f066ab)

En GNU/Linux, los permisos o derechos que los usuarios pueden tener sobre determinados archivos contenidos en él se etablecen en tres niveles claramente diferenciados. Estos tres niveles son los siguientes:

* Permisos de propietario.
* Permisos del grupo.
* Permisos del resto de usuarios(o también llamados "Los otros")

Para tenenr claros estos conceptos, en los sistemas en red(como lo es el pingüino) siempre existe la figura del administrador, superusuario o root. Este administrador es el encargado de crear y dar de baja a usuarios, así como también, de establecer los privilegios que cada uno de ellos tendrá en el sistema. Estos privilegios se establecen tanto para el directorio HOME de cada usuario como para los directorios y archivos a los que el administrador decida que el usuario pueda acceder.

#### Permisos del propietario

El propietario es aquel usuario que genera o crea un archivo/carpeta dentro de su directorio de trabajo (HOME), o en algún otro directorio sobre el que tenga derechos. Cada usuario tiene la potestad de crear, por defecto, los archivos que quiera dentro su directorio de trabajo. En principio, él y solamente él será el que tenga acceso a la información contenida en los archivos y directorios que hay en su directorio HOME.

#### Permisos del grupo

Lo más normal es que cada usuario pertenezca a un grupo de trabajo. De esta forma, cuando se gestiona un grupo, se gestionan todos los usuarios que pertenecen a éste. Es decir, es más fácil integrar varios usuarios en un grupo al que se le conceden determinados privilegios en el sistema, que asignar los privilegios de forma independiente a cada usuario.

#### Permisos del resto de usuarios

Por último, también los privilegios de los archivos contenidos en cualquier directorio, pueden tenerlos otros usuarios que no pertenezcan al grupo de trabajo en el que está integrado el archivo en cuestión. Es decir, a los usuarios que no pertenecen al grupo de trabajo en el que está el archivo, pero que pertenecen a otros grupos de trabajo, se les denomina resto de usuarios del sistema.

![Propietario y grupos de los archivos](/img/3.png)

Rojo: Indica quien es el propietario.

Amarillo: Indica a que grupo pertenece cada uno de los archivos y carpetas.

Cada archivo en GNU/Linux queda identificado por 10 caracteres mismos a los que se les denomina **máscara**. De estos 10 caracteres, el primero (de izquierda a derecha) hace referencia al tipo de archivo. Los siguientes 9, de izquierda a derecha y en bloques de 3, hacen referencia a los permisos que se le conceden, respectivamente, al propietario, al grupo y al resto u otros.

El siguiente carácter de los archivos puede ser el siguiente:

![Primer carácter de la máscara de permisos](/img/4.png)

Los siguientes nueve caracteres son los permisos que se les concede a los usuarios del sistema. Cada tres caracteres, se referencian los permisos de propietario, grupo y resto de usuarios.

Los caracteres que definen estos permisos son los siguientes:

![permisos de usuario](/img/5.png)

#### Permisos para archivos

* Lectura: Permite, fundamentalmente, visualizar el contenido del archivo.
* Escritura: Permite modificar el contenido del archivo.
* Ejecución: Permite ejecutar el archivo como si de un programa ejecutable se tratese.

#### Permisos para directorios

* Lectura: Permite saber qué archivos y directorios contiene el directorio que tiene este permiso
* Escritura: Permite crear archivos en el directorio, bien sean archivos ordinarios o nuevos directorios. Se pueden borrar directorios, copiar archivos en el directorio, mover, cambiar el nombre, etc.
* Ejecución: Permite situarse sobre el directorio para poder examinar su contenido, copiar archivos de o hacia él. Si además se dispone de los permisos de escritura y lectura, se podrán realizar todas las operaciones posibles sobre archivos y directorios.

Nota: Si no se dispone del permiso de ejecución, podemos acceder a dicho directorio (aunque utilicemos el comando "cd"), ya que esta acción será denegada. También permite delimitar el uso de un directorio como parte de una ruta.

Si el permiso de ejecución de un directorio está desactivado, se podrá ver su contenido (si se cuenta con permiso de lectura), pero no se podrá acceder a ninguno de los objetos contenidos en él, pues para ello este directorio es parte del camino necesario para resolver la ubicación de sus objetos.

#### Asignación de permisos

El comando chmod (change mod) permite modificar la máscara para que se puedan realizar más o menos operaciones sobre archivos o directorios, dicho de otra forma, con chmod puedes quitar o eliminar derechos a cada tipo de usuarios, Si no se especifica el tipo de usuario al que queremos quitar, poner o asignar privilegios, lo que sucederá al realizar la operación es afectar a todos los usuarios simultáneamente.

Lo básico que hay que recordar es que debemos dar o quitar permisos en estos niveles:

![niveles de permisos](/img/6.png)

Tipos de permiso:

![niveles de permisos](/img/7.png)

```bash
# Dar permiso de ejecución al dueño
chmod u+x script.sh
# Quitar permiso de ejecución a todos los usuarios
chmod -x script.sh
# Dar permiso de lectura y escritura a los demás usuarios
chmod o+r+w script.sh
# Dejar solo permiso de lectura al grupo al que pertenece el archivo
chmod g+r-w-x script.sh
```

#### Permisos en formato numérico octal

La combinación de bits encendidos o apagados en cada grupo da ocho posibles combinaciones de valores, es decir la suma de los bits encendidos:

* x = 1
* w = 2
* r = 4

![Formas de dar permiso de manera octal](/img/8.png)

Cuando se combinan los permisos del usuario, grupo y otros, se obtienen un número de tres cifras que conforman los permisos del archivo o del directorio.

![Ejemplos de uso de permisos octales](/img/9.png)

#### Permisos especiales

* Permiso SUID (Set User ID)
  * El bit setuid es asignable a ficheros ejecutables, y permite que cuando un usuario ejecute dicho fichero, el proceso adquiera los permisos del propietario del fichero ejecutado. Para asignar este bit a un fichero será:
    * chmod u+s /bin/su
* Permiso SGID (Set Group ID)
  * El bit SETID permite adquirir los privilegios del grupo asignado al fichero, también es asignable a directorios. Esto será muy útil cuando varios usuarios de un mismo grupo necesiten trabajar con recursos dentro del mismo directorio. Para asignar este bit hacemos lo siguiente:
    * chmod g+s /carpet_compartida
* Permiso de persistencia (Sticky Bit)
  * Este bit suele asignarse en directorios a los que todos los usuarios tienen acceso, y permite evitar que un usuario pueda borrar ficheros/directorios de otro usuario dentro de ese directorio, ya que todos tienen permiso de escritura. Para asignar este bit hacemos lo siguiente:
    * chmod o+t /tmp

[Permisos básicos en Linux](https://www.profesionalreview.com/2017/01/28/permisos-basicos-linux-ubuntu-chmod/)

### Lectura e interpretación de permisos [2-2]

[Cambiar permisos con comandos](https://www.hostinger.es/tutoriales/cambiar-permisos-y-propietarios-linux-linea-de-comandos/)

Para cambiar permisos de archivos y carpetas usamos el comando chmod

Para cambiar los propietarios de archivos y carpetas usamos el comando chown

```bash
cat /etc/shadow # Tiene las contraseñas encriptadas
cat /etc/login.defs | grep "ENCRYPT_METHOD"
```

### Asignación de permisos [1-2]

[Asignación de permisos](https://www.ionos.es/digitalguide/servidores/know-how/asignacion-de-permisos-de-acceso-con-chmod/)

[Propietarios y permisos](https://atareao.es/tutorial/terminal/propietarios-y-permisos/)

```bash
chgrp grupo directorio # le pasas el grupo y el directorio para que se cambie de grupo
```

### Asignación de permisos [2-2]

[Gestión de usuarios, grupos y permisos en Linux](https://computernewage.com/2016/05/22/gestionar-usuarios-y-permisos-en-linux/)

[Gestión de usuarios y grupo en linux](https://atareao.es/como/gestion-de-usuarios-y-grupos-en-linux/)

```bash
cd /home
sudo su
ls
> ethicalmachine
mkdir gerardo # Creamos el directorio que asignaremos a nuestro usuario
useradd gerardo -s /bin/bash -d /home/gerardo # Creamos el usuario, le asignamos una shell y el directorio que será su home

cat /etc/passwd | grep gerardo
> gerardo:x:1001:1002::/home/gerardo:/bin/bash

cat /etc/group | grep gerardo
> gerardo:x:1002

passwd gerardo
> Nueva contraseña: savitar
> Repetir contraseña: savitar

chgrp gerardo gerardo # valor1=grupo valor2=directorio, asigno al grupo gerardo el directorio gerardo

chown gerardo gerardo # valor1=propietario valor2=directorio, asigno a gerardo el directorio gerardo

chown propietario:grupo directorio # Para cambiar permisos en una linea

chown root:savitar /test # El propietario es root, el grupo es savitar del directorio test

groupadd Alumnos # Creamos grupo alumno
cat /etc/group
> Alumnos:x:1004:

usermod -a -G Alumnos gerardo # Con esta instrucción añadimos al usuario gerardo al grupo ALumnos
cat /etc/group
> Alumnos:x:1004:gerardo # Se añadió a gerardo al grupo alumnos
id # Nos muestra por consola los grupos a los que estamos añadidos

chmod o-rx nombre_directorio/ # Otros, no pueden leer ni atraveser el directorio

chgrp Alumnos nombre_directorio/ # Asigno al grupo Alumnos al directorio

chmod g+w nombre_directorio/ # Permito que los pertenecientes al grupo Alumnos puedan escribir en el directorio

sudo gpasswd -d username groupname # Eliminamos al usuario username del grupo groupname

sudo usermod -G groupname username # Eliminamos un usuario de un grupo

# userdel, es un programa del sistema. Modifica los archivos de cuentas de usuario del sistema, eliminando todas las entradas que hacen referencia al nombre de cuenta que vamos a eliminar. La cuenta de usuario deberá existir para poder eliminarla.

userdel -f, --force # Esta opción fuerza la eliminación de la cuenta de usuario incluso si el usuario todavia esta conectado. También obliga a userdel a eliminar el directorio de inicio del usuario y la cola de correo, incluso si otro usuario usa el mismo directorio de inicio o si la cola de correo no es propiedad del usuario especificado

sudo userdel -r gerardo # Eliminamos al usuario gerardo del sistema, borrará el directorio de inicio del usuario /home/gerardo y la cola de correo del usuario. Los archivos ubicados en otros sistemas de archivos deberán buscarse y eliminarse manualmente.

```

### Notación octal de permisos

La forma más recomendable de asignar permisos.

El consejo de savitar es recordar: 4 2 1, lo compara contra la máscara y hace la traducción

```bash
mkdir testing
chmod 755 testing
la
> drwxr-xr-x    root    root    testing
```

[Permisos del sistema de archivos GNU/Linux](https://blog.alcancelibre.org/staticpages/index.php/permisos-sistema-de-archivos)

### Permisos especiales - Sticky Bit

[¿Qué es el Sticky Bit y cómo configurarlo?](https://keepcoding.io/blog/que-es-el-sticky-bit-y-como-configurarlo/)

[El bit Sticky | Tutorial de GNU/Linux](https://www.fpgenred.es/GNU-Linux/el_bit_sticky.html)

El Sticky Bit en GNU/Linux es un **permiso especial** que se aplica sobre directorios (no sobre archivos normales en la mayoría de casos actuales) para controlar qué usuarios pueden eliminar o renombrar archivos dentro de ese directorio.

#### Origen historico

* En sistemas UNIX antiguos, el sticky bit en **archivos ejecutables** indicaba que, una vez ejecutado, el binario debía quedarse "pegado" en memoria (o en el swap) para acelerar posteriores ejecuciones.
* Hoy, ese uso **ya no se emplea** en sistemas modernos: su función principal quedó limitada a **directorios**.

#### Función actual en directorios

Cuando un directorio tiene el sticky bit activado:

* **Todos los usuarios pueden crear archivos** (si el permiso w en el directorio lo permite).
* **Solo el propietario del archivo, el propietario del directorio o el superusuario (root)** pueden eliminarlo o renombrarlo.
* **Otros usuarios no pueden borrar o renombrar archivos que no les pertenecen**, aunque tengan permiso de escritura sobre el directorio.

Sin Sticky Bit, si un directorioes escribible por todos (chmod 777), cualquiera podría borrar o modificar archivos de otros.

#### Ejemplo práctico

Supongamos un directorio /compartido donde todos pueden escribir

```bash
sudo mkdir /compartido
sudo chmod 777 /compartido
```

Ahora:

* Usuario juan crea un archivo nota.txt en /compartido.
* Usuario maria podría **borrarlo** sin problemas, porque el directorio es escribible por todos.

Activando el sticky bit:

```bash
sudo chmod 1777 /compartido && chmod +t /compartido
```

Esto cambia los permisos visible con ls -ld:

```bash
drwxrwxrwt 2 root root 4096 ago 14 /compartido
```

Fijate en la t al final de drwxrwxrw**t** eso indica que el sticky bit esta activo.

Ahora:

* juan puede borrar **sus** archivos.
* maria no podrá borrar archivos de juan, aunque el directorio sea escribible por todos.

También puedes usar **modo numérico:**

* chmod 1777 directorio -> permisos 777 + sticky bit.
* El primer dígito (1) es el que activa el sticky bit (igual que 2 sería setgid y 4 setuid).

Resumen rápido:

* Qué es: Permiso especial que evita que otros borren/renombren tus archivos en directorios compartidos.
* Dónde usarlo: En carpetas con permisos de escritura para varios usuarios (ej: /tmp, carpetas de intercambio).
* Cómo verlo: ls -ld muestra una t al final de los permisos.

### Control de atributos de ficheros en Linux - Chattr y Lsattr

[Control de atributos de ficheros Linux](https://rm-rf.es/chattr-y-lsattr-visualizar-y-modificar-atributos-en-sistemas-de-ficheros-linux/#:~:text=El%20primer%20comando%2C%20lsattr%20permite,chmod%2C%20chown%2Csetfacl%E2%80%A6)

[Comandos Chattr y Lsattr en Linux](https://programmerclick.com/article/5604675172/)

Esto es distinto de los permisos (rwx): Son banderas a nivelde inode que el kernel respeta y que pueden cambiar el comportamiento de archivos y directorios, sobre todo en ext2/3/4 (algunas tambien aplican en btrfs/xfs).

#### ¿Para qué sirven chattr y lsattr?

* chattr: cambia (añade, quita o fija) atributos especiales de archivos y directorios.
* lsattr: lista los atributos actuales para que puedas ver qué hay aplicado.

Muchos privilegios requieren de root, para establecerse (ej. +i, +a). El soporte varía por sistema de archivos, en ext4 funciona la mayoría "clásicos".

#### Atributos más útiles (y seguros de usar)

Entre corchetes, ejemplos típicos de uso:

* i - immutable (inmutable): El archivo **no puede modificarse, borrarse, renombrarse, ni truncarse**; ni root puede escribir salvo que quite el atributo primero. [Proteger archivos críticos de config]

```bash
sudo chattr +i /etc/resolv.conf
sudo chattr -i /etc/resolv.conf
```

* a - append-only (solo añadir): El archivo **solo admite escritura al final**; no se puede ni sobreescribir. Ideal para logs. [Evitar manipulación de logs]

```bash
sudo chattr +a /var/log/mi_app.log
sudo chattr -a /var/log/mi_app.log
```

* A - no atime: No actualiza la marca de acceso (atime) en lecturas. Reduce escrituras. (Ojo: Muchos sistemas usan relatime por defecto y esto puede no aportar mucho)

```bash
sudo chattr +A archivo
sudo chattr -A archivo
```

* d - nodump: Excluye el archivo/directorio de herramientas tipo dump. [Evitar que ciertos datos entren en respaldos hechos con dump]

```bash
sudo chattr +d carpeta_temporal/
```

* S - synchronous updates (Sincrónico): Cada escritura se sincroniza inmediatemente a disco (solo para este archivo). [Datos críticos pero pequeños]

```bash
sudo chattr +S fichero_pequeño_critico
```

* D - dirsync (Sincrónico para directorios): Cambios en la escritura del directorio (crear/borrar/renombrar entradas) se hacen sincrónicamente. [Directorios con metadatos muy sensibles a pérdida]

```bash
sudo chattr +D /srv/critico/
```

* j - data journaling (ext3/4): Fuerza journaling de datos (no solo metadatos) para ese archivo en ext3/4. Aumenta seguridad pero tambien I/O.

```bash
sudo chattr +j archivo_en_ext4
```

* C - no CoW (copy on write): Desactiva CoW en fs que lo soportan (útil en btrfs para VM/discos/DB que sufren fragmentación con CoW). No tiene efecto en ext4 (ext no usa CoW)

```bash
sudo chattr +C /btrfs/imagenes/vm.qcow2
```

* T - top of directory hierarchy: Pista para el asignador de bloques (ayuda a rendimiento en ciertas jerarquías grandes). Útil en raíces de árboles de proyectos/datos.

```bash
sudo chattr +T /datos/proyectos
```

#### Atributos informativos (no cambiarlos)

Estos suelen aparecer en lsattr, pero no se setean manualmente:

* e: el archivo usa extents(ext4)
* I: directorio indexado (htree) en ext4.
* h: archivo "grande" (huge)

Atributos como c, s, u, t, X, Z están obsoletos, eran experimentales o dependen de otros FS/Parches. Evitarlos salvo que sepa que mi FS lo soporta.

#### Chuleta rápida

```bash
sudo chattr +i archivo     # inmutable
sudo chattr -i archivo

sudo chattr +a archivo     # solo append
sudo chattr -a archivo

sudo chattr +A archivo     # no atime
sudo chattr -A archivo

sudo chattr +S archivo     # escritura sincrónica
sudo chattr +D directorio  # dirsync

sudo chattr +j archivo     # data journaling (ext3/4)
sudo chattr +C archivo     # no CoW (btrfs)
sudo chattr +T directorio  # top of dir hierarchy
```

### Permisos especiales - SUID y SGID

[Permisos SGID, SUID, Sticky Bit](https://deephacking.tech/permisos-sgid-suid-y-sticky-bit-linux/#:~:text=Permiso%20SGID,-El%20permiso%20SGID&text=Si%20se%20establece%20en%20un,perteneciente%2C%20el%20grupo%20del%20directorio.)

[Permisos especiales en Linux](https://www.ochobitshacenunbyte.com/2019/06/17/permisos-especiales-en-linux-sticky-bit-suid-y-sgid/)

[Los bits SUID, SGID y Sticky](https://www.ibiblio.org/pub/linux/docs/LuCaS/Manuales-LuCAS/SEGUNIX/unixsec-2.1-html/node56.html)

```bash
which python3.11
> /usr/bin/python3.11

which python3.11 | xargs ls -l # A la ruta que nos arroje el primero comando le hacemos un ls -l

> -rwxr-xr-x 1 root root 5479736 feb 28 2021 /usr/bin/python3.11

chmod u+s /usr/bin/python3.11

which python3.11 | xargs ls -l # A la ruta que nos arroje el primero comando le hacemos un ls -l

> -rwsr-xr-x 1 root root 5479736 feb 28 2021 /usr/bin/python3.11 # Se añade el permiso setuid s al usuario

# De esta manera buscamos los binarios con suid, encontramos una vulnerabilidad en python
find / -type f -perm -4000 2>/dev/null # Buscar archivos con privilegios suid y mandamos el error al dev null
find / -type f -perm -2000 2>/dev/null # Buscar archivos con privilegios sgid y mandamos el error al dev null

# Terminamos esta actividad abriendo python, import os, os.setuid(0), os.system("whoami")=root, os.system("bash")=nos da una bash como root

chmod u-s /usr/bin/python3.11

```

#### Chuleta de permisos Sticky Bit, SGID, SUID

* 1 = Sticky bit
* 2 = SGID
* 4 = SUID

Ejemplos:

```bash
chmod 4755 archivo   # SUID + rwxr-xr-x
chmod 2755 archivo   # SGID + rwxr-xr-x
chmod 6755 archivo   # SUID y SGID

find / -perm -4000 2>/dev/null   # busca todos los archivos con SUID
find / -perm -2000 2>/dev/null   # busca todos los archivos con SGID
```

### Privilegios especiales - Capabilities

[¿Qué son las Linux Capabilities](https://gtfobins.github.io/#+capabilities)

```bash
# Listamos las capabilities y los errores los dirigimos al dev null
getcap -r / 2>/dev/null

# Como prueba de concepto, Savitar establecio la capabilitie a
setcap cap_setuid+ep /usr/bin/python3.11
getcap /usr/bin/python3.11
> /usr/bin/python3.11 cap_setuid=ep

# Como prueba de concepto, Savitar quitó la capabilitie a
setcap -r /usr/bin/python3.11
getcap /usr/bin/python3.11
> /usr/bin/python3.11
```

### Utilerias

* Instalar cat mejorado -> batcat
  * Modificar archivo .bashrc
    * alias bc='batcat'
* Instalar cat mejorado -> lsd
  * Modificar archivo .bashrc
    * alias ls='lsd'
* Personalizar la terminal -> PowerLevel10k
* Recargar terminal -> source ~/.bashrc

### Troubleshooting

---

Mistake: **Command not found**

```bash
> bash: usermod: command not found
printenv || env # Nos muestra configuraciones de las variables de entorno gobales en el sistema

nano .bashrc # Añadimos hasta el final del archivo la línea
export PATH=$PATH:/srv/scripts # Con esta instrucción estamos agregando ese directorio al final de todo el path

# Mi solucion fue copiar el path de super usuario y pegarlo de la siguiente manera
export PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

```
