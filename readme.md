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

### Estructura de directorios del sistema

#### Estructura general de directorios en Linux (FHS - FileSystem Herarchy Standard)

Linux sigue un estándar llamado FHS.

```java
/
├── bin    → Binarios esenciales del sistema (ls, cp, mv, cat, etc.)
├── boot   → Archivos de arranque (kernel vmlinuz, initrd, grub)
├── dev    → Dispositivos (hdd, usb, tty, null, etc.) como archivos especiales
├── etc    → Archivos de configuración del sistema y servicios
├── home   → Directorios personales de los usuarios
├── lib    → Bibliotecas esenciales compartidas para binarios de /bin y /sbin
├── media  → Puntos de montaje automáticos para CDs, USBs, etc.
├── mnt    → Punto de montaje manual para admins (ej. montar discos temporales)
├── opt    → Paquetes opcionales / software de terceros
├── proc   → Sistema de archivos virtual con info del kernel y procesos
├── root   → Directorio personal del superusuario (root)
├── run    → Info de ejecución en tiempo real (PID files, sockets, etc.)
├── sbin   → Binarios esenciales de administración (mount, shutdown, ifconfig…)
├── srv    → Datos de servicios (web, ftp, repositorios locales)
├── sys    → Información del kernel (dispositivos, módulos, controladores)
├── tmp    → Archivos temporales (se borran en cada reinicio)
├── usr    → Programas y utilidades para usuarios
│   ├── bin   → Binarios no esenciales (cp, nano, firefox, etc.)
│   ├── lib   → Librerías para los binarios de /usr/bin y /usr/sbin
│   ├── sbin  → Binarios de administración no esenciales
│   └── share → Archivos compartidos (documentación, íconos, locales)
└── var    → Datos variables: logs, colas de correo, caché, bases de datos
```

#### Particularidades de Parrot OS Security

Además de la estructura básica, Parrot añade directorios específicos para seguridad y pentesting.

* /usr/share/ -> Aquí encontrarás la mayoría de herramientas de hacking y pentesting instaladas por defecto. Ejemplos:
  * /usr/share/metasploit-framework/
  * /usr/share/wordlists/ (diccionarios como rockyou.txt)
  * /usr/share/nmap/
  * /usr/share/exploitdb/
* /etc/ -> Configuraciones de servicios de seguridad que Parrot trae integrados:
  * /etc/tor/ -> Configuración de TOR.
  * /etc/proxychains.conf -> Proxychains para redirigir tráfico.
  * /etc/network/ -> Configuración de red y VPNs.
  * /etc/ssh/ -> Config de servidor/cliente SSH.
* /var/log/ -> Logs de servicios de seguridad:
  * /var/log/auth.log -> Autenticaciones
  * /var/log/tor/ -> Logs de TOR.
  * /var/log/apache2/ -> Logs de Apache (Si lo tienes activo para pentesting web).
* /home/ -> Tus directorios personales; aquí normalmente guardarás proyectos, scripts y reportes de auditorías.

#### Directorio Raíz

El directorio raíz, simbolizado por el símbolo (/), es el directorio principal a partir del cual se ramifican todo el resto de directorios.

#### Directorio /bin

El directorio /bin es un directorio estático y compartible en el que se almacenan archivos binarios/ejecutables necesarios para el funcionamiento del sistema. Estos archivos binarios los pueden usar la totalidad de usuarios del sistema operativo.

#### Directorio /boot

Es un directorio estático no compartible que contiene la totalidad de archivos necesarios para el arranque del ordenador excepto los archivos de configuración. Algunos de los archivos indispensables para el arranque del sistema que acostumbra a almacenar el directorio /boot son el kernel y el gestor de arranque Grub.

#### Directorio /dev

El sistema operativo Gnu-Linux trata los dispositivos de hardware como si fueran un archivo. Estos archivos que representan nuestros dispositivos de hardware se hallan almacenados en el directorio /dev.

Algunos de los archivos básicos que podemos encontrar en este directorio son:

* cdrom que representa nuestro dispositivo de CDROM.
* sda que representa nuestro disco duro sata.
* audio que representa nuestra tarjeta de sonido.
* psaux que representa el puerto PS/2.
* lpx que representa nuestra impresora.
* fd0 que representa nuestra disquetera.

#### Directorio /etc

El directorio /etc es un directorio estático que contiene los archivos de configuración del sistema operativo. Este directorio también contiene archivos de configuración para controlar el funcionamiento de diversos programas.

Algunos de los archivos de configuración de la carpeta /etc pueden ser sustituidos o complementados por archivos de configuración ubicados en nuestra carpeta personal /home.

#### Directorio /home

El directorio /home se trata de un directorio variable y compartible. Este directorio está destinado a alojar la totalidad de archivos personales de los distintos usuarios del sistema operativo a excepción del usuario root. Algunos de los archivos personales almacenados en la carpeta /home son fotografías, documentos de ofimática, vídeos, etc.

#### Directorio /lib

El directorio /lib es un directorio estático y que puede ser compartible. Este directorio contiene bibliotecas compartidas que son necesarias para arrancar los ejecutables que se almacenan en los directorios /bin y /sbin.

#### Directorio /mnt

El directorio /mnt tiene la finalidad de albergar los puntos de montaje de los distintos dispositivos de almacenamiento como por ejemplo discos duros externos, particiones de unidades externas, etc.

#### Directorio /media

La función del directorio /media es similar a la del directorio /mnt. Este directorio contiene los puntos de montaje de los medios extraíbles de almacenamiento como por ejemplo memorias USB, lectores de CD-ROM, unidades de disquete, etc.

#### Directorio /opt

El contenido almacenado en el directorio /opt es estático y compartible. La función de este directorio es almacenar programas que no vienen con nuestro sistema operativo como por ejemplo Spotify, Google-earth, Google Chrome, Teamviewer, etc.

#### Directorio /proc

El directorio /proc se trata de un sistema de archivos virtual. Este sistema de archivos virtual nos proporciona información acerca de los distintos procesos y aplicaciones que se están ejecutando en nuestro sistema operativo.

#### Directorio /root

El directorio /root se trata de un directorio variable no compartible. El directorio /root es el directorio /home del administrador del sistema (usuario root).

#### Directorio /sbin

El directorio /sbin se trata de un directorio estático y compartible. Su función es similar al directorio /bin, pero a diferencia del directorio /bin, el directorio /sbin almacena archivos binarios/ejecutables que solo puede ejecutar el usuario root o administrador del sistema.

#### Directorio /srv

El directorio /srv se usa para almacenar directorios y datos que usan ciertos servidores que podamos tener instalados en nuestro ordenador.

#### Directorio /tmp

El directorio /tmp es donde se crean y se almacenan los archivos temporales y las variables para que los programas puedan funcionar de forma adecuada.

#### Directorio /usr

El directorio /usr es un directorio compartido y estático. Este directorio es el que contiene la gran mayoría de programas instalados en nuestro sistema operativo.

Todo el contenido almacenado en la carpeta /usr es accesible para todos los usuarios y su contenido es solo de lectura.

#### Directorio /var

El directorio /var contiene archivos de datos variables y temporales como por ejemplo los registros del sistema (logs), los registros de programas que tenemos instalados en el sistema operativo, archivos spool, etc.

La principal función del directorio /var es la detectar problemas y solucionarlos. Se recomienda ubicar el directorio /var en una partición propia, y en caso de no ser posible es recomendable ubicarlo fuera de la partición raíz.

#### Directorio /sys

Directorio que contiene información similar a la del directorio /proc. Dentro de esta carpeta podemos encontrar información estructurada y jerárquica acerca del kernel de nuestro equipo, de nuestras particiones y sistemas de archivo, de nuestros drivers, etc.

#### Directorio /lost-found

Directorio que se crea en las particiones de disco con un sistema de archivos ext después ejecutar herramientas para restaurar y recuperar el sistema operativo como por ejemplo fsch.

Si nuestro sistema no ha presentado problemas este directorio estará completamente vacío. En el caso que hayan habido problemas este directorio contendrá ficheros y directorios que han sido recuperados tras la caída del sistema operativo.

### Uso de bashrc y zshrc

[¿Qué es bashrc en Linux?](https://www.compuhoy.com/que-es-bashrc-en-linux/)

[¿Por qué deberías usar ZSH?](https://respontodo.com/que-es-zsh-y-por-que-deberia-usarlo-en-lugar-de-bash/)

En mi caso yo opero con una ZSH, por tanto mi archivo de configuración corresponde al ‘~/.zshrc‘. Recuerda que en caso de usar una BASH tu archivo de configuración debería estar situado en ‘~/.bashrc‘

### Actualización y Upgradeo del sistema Parrot OS Security

```bash
apt update # Para actualizar paquetes

apt list --upgradable # Para listar paquetes upgradear

parrot-upgrade # Para actualizar el sistema operativo
```

### Uso y manejo con Tmux

Para tener todos los atajos y comando de Tmux centralizados, hemos creado la siguiente guía la cual esperamos que le puedas sacar provecho:

[Guía de atajaos y comandos de Tmux](https://hack4u.io/wp-content/uploads/2022/05/Tmux-Cheat-Sheet.pdf)

[Página para personalizar tmux con ohmytmux](https://github.com/gpakosz/.tmux)

```bash
# Iniciar una nueva sesión
tmux
tmux new
tmux new-session
:new
# Empezar una nueva sesión con un nombre
tmux new -s mysession
:new -s mysession
# Matar/Borrar la sesión mysession
tmux kill-sesion -t mysession
# Matar/borrar todas las sesiones excepto la actual
tmux kill-session -a
# Matar/borrar todas las sesiones excepto mysession
tmux kill-session -a -t mysession
# Renombrar todas las sesiones
Ctrl + b $
# Desvincularse de la sesión
Ctrl + b d
# Mostrar todas las sesiones activas
tmux ls
Ctrl + b s
# Sincronizarse a la última sesión
tmux a
tmux at
tmux attach
tmux attach-session
# Sincronizarse a la sesion mysession
tmux a -t mysession
tmux attach-session -t mysession
# Moverse a la sesión anterior
Ctrl + b (
Ctrl + b )
# Activar el uso del mouse
Ctrl + b m


# Ventanas
# Empezar una nueva sesión con nombre mysession y nombre de ventana mywindow
tmux new -s mysession -n window
# Crear una nueva ventana
Ctrl + b c
# Renombrar la ventana actual
Ctrl + b ,
# Cerrar la ventana actual
Ctrl + b &
# Ventana anterior
Ctrl + b p
# Ventana siguiente
Ctrl + b n
# Alternar/Seleccionar ventana por número
Ctrl + b 0...9
# Reordenar ventanas, intercambiar la ventana 2 (origen) por 1 (destino)
swap-window -s 2 -t 1
# Mover la ventana actual a la izquierda en una posición
swap-window -t -1


# Paneles
# Conmutar el último panel activo
Ctrl + b ;
# Dividir el panel verticalmente
Ctrl + b %
# Dividir el panel horizontalmente
Ctrl + b ''
# Mueve el panel actual a la izquierda
Ctrl + b {
# Mueve el panel actual a la derecha
Ctrl + b }
# Intercambia el panel en la dirección indicada
Ctrl + b up, down, left, rigth
# Sincronizar paneles (enviar el comando indicado a todos los paneles)
setw synchronize-panes
# Alternar entre los diseños de los paneles
Ctrl + b Spacebar
# Cambiarse al siguiente panel
Ctrl + b o
# Mostrar los números de los paneles
Ctrl + b q
# Alternar/Seleccionar panel por número
Ctrl + b q 0...9
# Establecer zoom en el panel actual
Ctrl + b z
# Convierte el panel en una ventana
Ctrl + b !
# Redimensionar la altura del panel actual
Ctrl + b + up, down
# Redimensionar la anchura del panel actual
Ctrl + b + -> <-
# Cerrar el panel actual
Ctrl + b x



# MODO COPIA
# Utilizar las teclas de vi en el buffer
setw -g mode-keys vi
# Entrar al modo copia
Ctrl + b [
# Desplazarse de una página hacia arriba
Ctrl + b PgUp
# Modo salida
q
# Ir a la línea superior
g
# Ir a la línea inferior
G
# Mover el cursor a la izquierda
h
# Mover el cursos a la derecha
l
# Mover el cursor abajo
j
# Mover el cursor arriba
k
# Mover el cursor hacia adelante una palabra a la vez
w
# Mover el cursor hacia atras una palabra a la vez
b
# Búsqueda hacia adelante
/
# Búsqueda hacia atras
?
# Siguiente palabra clave
n
# Ocurrencia de la palabra anterior
N
# Iniciar selección
Spacebar
# Limpiar selección
Esc
# Copiar selección
Enter
# Pegar contenido del buffer_0
Ctrl + b ]
# Mostrar contenido del buffer_0
show-buffer
# Copiar todo el contenido visible del panel a un buffer
capture-pane
# Mostrar todos los buffers
list-buffers
# Mostrar todos los buffers y pegar lo seleccionado
choose-buffer
# Guardar el contenido del buffer en buf.txt
save-buffer buf.txt
# Borrar buffer_1
delete-buffer -b 1



# VARIOS
# Entrar en modo comandos
Ctrl + b :
# Establecer un OPTION para todas las sesiones
set -g OPTION
# Establecer un OPTION para todas las ventanas
setw -g OPTION
# Mostrar cada sesión, ventana, panel, etc.
tmux info
# Mostrar shortcuts
Ctrl + b ?
```

### Búsquedas a nivel de sistema

[Comandos Find y Locate en Linux](https://www.hostinger.es/tutoriales/como-usar-comando-find-locate-en-linux/)

#### ¿Qué es find?

Es una herramienta de línea de comandos que busca archivos y directorios en un árbol de directorios, aplicando criterios de búsqueda (nombre, tipo, permisos, propietario, fechas, tamaño, etc.) y permite ejecutar acciones sobre lo encontrado.

Se diferencia de locate porque:

* locate buscar en una base de datos indexada (más rápido, pero no en tiempo real).
* find busca directamente en el sistema de archivos (más lento, pero exacto).

#### Sintaxis básica

```bash
find [ruta_inicial] [criterios] [acciones]

find /home -name "*.txt" # Busca todos los archivos .txt en /home
```

#### Criterios de búsqueda más comunes

* Por nombre

```bash
find /etc -name "hosts"
find /var/log -iname "*.log" # -iname ignora mayúsculas
```

* Por tipo

```bash
find / type f # Solo archivos
find / type d # Solo directorios
find / type l # Solo enlaces simbólicos
```

* Por usuario o grupo

```bash
find /home -user jose
find /var -group www-data
```

* Por permisos

```bash
find / -perm 644 # Archivos con permisos 644 exactos
find / -perm -4000 # Archivos con SUID
find / -perm -2000 # Archivos con SGID
```

* Por fechas

```bash
find /home -mtime -1 # Modificados en el último día
find /var/log -atime -7 # Leídos en los últimos 7 días
find /etc -ctime -2 # Cuyo inode cambió en 2 días
```

* Por tamaños

```bash
find / -size +100M # Mayores de 100 MB
find /var/log -size -50k # Menores de 50 KB
```

### Creación de scripts en bash

Paleta con colores para usar en bash

```bash
#Colours
greenColour="\e[0;32m\033[1m"
endColour="\033[0m\e[0m"
redColour="\e[0;31m\033[1m"
blueColour="\e[0;34m\033[1m"
yellowColour="\e[0;33m\033[1m"
purpleColour="\e[0;35m\033[1m"
turquoiseColour="\e[0;36m\033[1m"
grayColour="\e[0;37m\033[1m"

trap ctrl_c INT
```

* Script que me da la dirección IP

```bash
sudo su
cd /home
touch script.sh
chmod +x script.sh
nano script.sh
#!/bin/bash
echo -e "\n[+] Esta es tu dirección IP -> $(ip a | grep "inet " | tail -n 1 | awk '{print $2}' | awk '{print $1}' FS="/")\n" # Los comandos van dentro de $()

echo -e "\n${yellowColour}[+]${endColour}${blueColour} Esta es tu dirección IP ->${endColour}${redColour}$(ip a | grep "inet " | tail -n 1 | awk '{print $2}' | awk '{print $1}' FS="/")\n${endColour}" # Los comandos van dentro de $()
```

### Uso y configuración de la Kitty

[Overview - Kitty](https://sw.kovidgoyal.net/kitty/overview/)

* Para configurar la kitty, tuve que buscar el archivo de configuracion con el siguiente comando

```bash
find / -type f -iname "kitty.conf" 2>/dev/null
cat /etc/xdg/kitty/kitty.conf
> update_check_interval 0

sudo nano /etc/xdg/kitty/kitty.conf
font_size 15
background_opacity 0.90
```

* Funciones de Kitty

```bash
ctrl + left # Moverse entre paneles a la izquierda
ctrl + right # Moverse entre paneles a la derecha
ctrl + up # Moverse entre paneles hacia arriba
ctrl + down # Moverse entre paneles hacia abajo
ctrl + shift + enter # Abre un panel nuevo
ctrl + shift + r # Redimensionar panel
q # Para salir de redimensionado
ctrl + shift + w # Para cerrar la ventana
ctrl + shift + l # Para organizar las ventanas aleatoriamente
ctrl + shift + . # Moverme entre ventanas hacia adelante
ctrl + shift + , # Moverme entre ventanas hacia atras
ctrl + shift + t # Crear nueva pestaña en la ventana
ctrl + shift + n # Crea nueva ventana
ctrl + shift + alt + t # Cambiar el nombre a las pestañas 
ctrl + shift + izquierda # Regresar a la pestaña anterior
ctrl + shift + derecha # avanzar a la pestaña siguiente
```

### Uso del editor VIM

Configurar vim como lo tiene savitar, pero más adelante

### Conexiones SSH | Inicia Bandit

### Abusando de tareas Cron [1-3]

Cron es un administrador de tareas de Linux que permite ejecutar comandos en un momento determinado, por ejemplo, cada minuto, día, semana o mes. Si queremos trabajar con cron, podemos hacerlo a través del comando **crontab**.

El formato de configuración de cron es el siguiente: Minuto Hora Dia-del-Mes Mes Dia-de-la-semana Comando-a-ejecutar

El intervalo de tiempo se especifica mediante 5 campos que representan, de izquierda a derecha:

* Minutos: de 0 a 59.
* Horas: de 0 a 23.
* Día del mes: de 1 a 31.
* Mes: de 1 a 12.
* Día de la semana: de 1 a 6 lunes a sabado(1=lunes, 2=martes, etc) y 0 o 7 el domingo.

Si quisieramos especificar todos los valores posibles de un parámetro (minutos, horas, etc) podemos hacer uso del asterisco. Esto implica que si en lugar de un número utilizamos un asterisco, el comando indicado se ejecutará cada minuto, hora, día de mes, mes o día de la semana, como en el siguiente ejemplo:

```bash
* * * * * /home/usr/script.sh
```

### Argumentos posicionales en Bash | Termina Bandit

En Bash se pueden usar argumentos desde la línea de comandos, los cuales son enviados a los scripts como variables. Estos quedarían representados de la siguiente forma:

[$0]: Representa el nombre del script que se invocó desde la terminal.

[$1]: Es el primer argumento desde la línea de comandos.

[$2]: Es el segundo argumento desde la línea de comandos y así sucesivamente.

[$#]: Contiene el número de argumentos que son recibidos desde la línea de comandos.

[$*]: Contiene todos los argumentos que son recibidos desde la línea de comandos, guardados todos en la misma variable.

```bash
#!/bin/bash

# Bandit 0
sshpass -p 'bandit0' ssh bandit0@bandit.labs.overthewire.org -p 2220
export TERM=xterm
cat readme | tail -n -2 | head -n -1 | awk '{print $8}'
# Flag: ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If



# Bandit 1
sshpass -p 'ZjLjTmM6FvvyRnrb2rfNWOZOTa6ip5If' ssh bandit1@bandit.labs.overthewire.org -p 2220
cat ./-
# Flag: 263JGJPfgU6LtdEvgfWU1XP5yac29mFx



# Bandit 2
sshpass -p '263JGJPfgU6LtdEvgfWU1XP5yac29mFx' ssh bandit2@bandit.labs.overthewire.org -p 2220
cat ./--spaces\ in\ this\ filename--
# Flag: MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx



# Bandit 3
sshpass -p 'MNk8KNH3Usiio41PRUEoDFPqfxLPlSmx' ssh bandit3@bandit.labs.overthewire.org -p 2220
ls -la
cd inhere/
ls -la
cat ./...Hiding-From-You
# Flag: 2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ



# Bandit 4
sshpass -p '2WmrDFRmJIq3IPxneAaMGhap0pFhF3NJ' ssh bandit4@bandit.labs.overthewire.org -p 2220
cd inhere/
find . -type f | grep "\-file" | xargs file
find . -type f | grep "\-file" | xargs file | grep "text"
cat ./-file07
# Flag: 4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw



# Bandit 5
sshpass -p '4oQYVPkxZOOEOO5pTW81FB8j8lxXGUQw' ssh bandit5@bandit.labs.overthewire.org -p 2220
find . -type f ! -perm /111 -size 1033c | xargs file
cat ./inhere/maybehere07/.file2 | head -n 1 | awk '{print $1}'
# Flag: HWasnPhtq9AVKe0dmk45nxy20cvUa6EG



# Bandit 6
sshpass -p 'HWasnPhtq9AVKe0dmk45nxy20cvUa6EG' ssh bandit6@bandit.labs.overthewire.org -p 2220
find / -user bandit7 -group bandit6 -size 33c 2>/dev/null | xargs file
cat /var/lib/dpkg/info/bandit7.password
# Flag: morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj



# Bandit 7
sshpass -p 'morbNTDkSW6jIlUc0ymOdMaLnOlFVAaj' ssh bandit7@bandit.labs.overthewire.org -p 2220
cat data.txt | grep "millionth" | awk '{print $2}'

# Flag: dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc



# Bandit 8
sshpass -p 'dfwvzFQi4mU0wfNbFOe9RoWskMLg7eEc' ssh bandit8@bandit.labs.overthewire.org -p 2220
cat data.txt | sort | uniq -u
# Flag: 4CKMh1JI91bUIZZPXDqGanal4xvAg0JM



# Bandit 9
sshpass -p '4CKMh1JI91bUIZZPXDqGanal4xvAg0JM' ssh bandit9@bandit.labs.overthewire.org -p 2220
cat data.txt | strings | grep "==========" | tail -n 1 | awk '{print $2}'
# Flag: FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey



# Bandit 10
sshpass -p 'FGUW5ilLVJrxX9kMYMmlN4MgbpfMiqey' ssh bandit10@bandit.labs.overthewire.org -p 2220
cat data.txt | base64 -d | awk '{print $4}'
# Flag: dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr



# Bandit 11
sshpass -p 'dtR173fZKb0RRsDFSGsg2RWnpNVj3qRr' ssh bandit11@bandit.labs.overthewire.org -p 2220
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m'
cat data.txt | tr 'A-Za-z' 'N-ZA-Mn-za-m' | awk '{print $NF}'
# Flag: 7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4



# Bandit 12
sshpass -p '7x16WNeHIi5YkIhWsfFIqoognUTyj9Q4' ssh bandit12@bandit.labs.overthewire.org -p 2220
cat data.txt
cp data.txt > hexdump
xxd -r hexdump > file
7z l file | tail -n 3 | head -n 1 | awk 'NF {print $NF}'
7z x file
7z l data2.bin | tail -n 3 | head -n 1 | awk 'NF {print $NF}'
7z x data2.bin

# SCRIPT CREADO
 #!/bin/bash
 
 function ctrl_c(){
     echo -e "\n\n[!] Saliendo...\n"
 }
 
 # Ctrl+C
 trap ctrl_c INT
 
 first_file_name="file"
 decompressed_file_name="$(7z l file | tail -n 3 | head -n 1 | awk 'NF{print $NF}'
 )"
 
 7z x $first_file_name &>/dev/null
 
 while [ $decompressed_file_name ]; do
     echo -e "\n[+] Nuevo archivo descomprimido: $decompressed_file_name"
     7z x $decompressed_file_name &>/dev/null
     decompressed_file_name="$(7z l $decompressed_file_name 2>/dev/null | tail -n 
 3 | head -n 1 | awk 'NF{print $NF}')"
 done

# Flag: FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn



# Bandit 13
sshpass -p 'FO5dwFsc0cbaIiH0h8J2eUks2vdTDwAn' ssh bandit13@bandit.labs.overthewire.org -p 2220
# Savitar nos dice que con ssh-keygen podemos crearnos una clave publica y una privada
# Savitar da enter, se crea bajo el directorio ~/.ssh dos archivos, clave publica: id_rsa.pub y clave privada: id_rsa

# Dicho de otra manera el comando siguiente: me voy a conectar con la clave como el usuario bandit14 al equipo localhost en el puerto 2220
ssh -i sshkey.private bandit14@localhost -p 2220
cat /etc/bandit_pass/bandit14 
# Flag: MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS


# Bandit 14
sshpass -p 'MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS' ssh bandit14@bandit.labs.overthewire.org -p 2220
nc localhost 30000
MU4VWeTyJk8ROof1qqmcBPaLh7lDCPvS
# Flag: 8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo



# Bandit 15
sshpass -p '8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo' ssh bandit15@bandit.labs.overthewire.org -p 2220
ncat --ssl localhost 30001
8xCjnmgoKbGLhHFAZlGE5Tmu4M2tKJQo
Correct!
kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx

# Flag: kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx



# Bandit 16
sshpass -p 'kSkvUpMQ7lBYyCM4GBPvCvT1BfWRy0Dx' ssh bandit16@bandit.labs.overthewire.org -p 2220
cd /tmp/
mktemp -d
/tmp/tmp.zfTzWLlxAP # Nos crea un directorio temporal de trabajo
cd /tmp/tmp.zfTzWLlxAP
touch portScan.sh
chmod +x portScan.sh
nano portScan.sh
# Inicio script
#/bin/bash

function ctrl_c(){
        echo -e "\n\n[!] Saliendo...\n"
        exit 1
}


# Ctrl+C
trap ctrl_c INT

for port in $(seq 31000 32000); do
        (echo ' ' > /dev/tcp/127.0.0.1/$port) 2>/dev/null && echo "[+] $port - OPEN" &
done;wait
# Fin script

./portScan.sh
[+] 31046 - OPEN
[+] 31518 - OPEN
[+] 31691 - OPEN
[+] 31790 - OPEN
[+] 31960 - OPEN

nmap -sV -p31000-32000 localhost

PORT      STATE SERVICE     VERSION
31046/tcp open  echo
31518/tcp open  ssl/echo
31691/tcp open  echo
31790/tcp open  ssl/unknown
31960/tcp open  echo

ncat --sl localhost 31790

-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAvmOkuifmMg6HL2YPIOjon6iWfbp7c3jx34YkYWqUH57SUdyJ
imZzeyGC0gtZPGujUSxiJSWI/oTqexh+cAMTSMlOJf7+BrJObArnxd9Y7YT2bRPQ
Ja6Lzb558YW3FZl87ORiO+rW4LCDCNd2lUvLE/GL2GWyuKN0K5iCd5TbtJzEkQTu
DSt2mcNn4rhAL+JFr56o4T6z8WWAW18BR6yGrMq7Q/kALHYW3OekePQAzL0VUYbW
JGTi65CxbCnzc/w4+mqQyvmzpWtMAzJTzAzQxNbkR2MBGySxDLrjg0LWN6sK7wNX
x0YVztz/zbIkPjfkU1jHS+9EbVNj+D1XFOJuaQIDAQABAoIBABagpxpM1aoLWfvD
KHcj10nqcoBc4oE11aFYQwik7xfW+24pRNuDE6SFthOar69jp5RlLwD1NhPx3iBl
J9nOM8OJ0VToum43UOS8YxF8WwhXriYGnc1sskbwpXOUDc9uX4+UESzH22P29ovd
d8WErY0gPxun8pbJLmxkAtWNhpMvfe0050vk9TL5wqbu9AlbssgTcCXkMQnPw9nC
YNN6DDP2lbcBrvgT9YCNL6C+ZKufD52yOQ9qOkwFTEQpjtF4uNtJom+asvlpmS8A
vLY9r60wYSvmZhNqBUrj7lyCtXMIu1kkd4w7F77k+DjHoAXyxcUp1DGL51sOmama
+TOWWgECgYEA8JtPxP0GRJ+IQkX262jM3dEIkza8ky5moIwUqYdsx0NxHgRRhORT
8c8hAuRBb2G82so8vUHk/fur85OEfc9TncnCY2crpoqsghifKLxrLgtT+qDpfZnx
SatLdt8GfQ85yA7hnWWJ2MxF3NaeSDm75Lsm+tBbAiyc9P2jGRNtMSkCgYEAypHd
HCctNi/FwjulhttFx/rHYKhLidZDFYeiE/v45bN4yFm8x7R/b0iE7KaszX+Exdvt
SghaTdcG0Knyw1bpJVyusavPzpaJMjdJ6tcFhVAbAjm7enCIvGCSx+X3l5SiWg0A
R57hJglezIiVjv3aGwHwvlZvtszK6zV6oXFAu0ECgYAbjo46T4hyP5tJi93V5HDi
Ttiek7xRVxUl+iU7rWkGAXFpMLFteQEsRr7PJ/lemmEY5eTDAFMLy9FL2m9oQWCg
R8VdwSk8r9FGLS+9aKcV5PI/WEKlwgXinB3OhYimtiG2Cg5JCqIZFHxD6MjEGOiu
L8ktHMPvodBwNsSBULpG0QKBgBAplTfC1HOnWiMGOU3KPwYWt0O6CdTkmJOmL8Ni
blh9elyZ9FsGxsgtRBXRsqXuz7wtsQAgLHxbdLq/ZJQ7YfzOKU4ZxEnabvXnvWkU
YOdjHdSOoKvDQNWu6ucyLRAWFuISeXw9a/9p7ftpxm0TSgyvmfLF2MIAEwyzRqaM
77pBAoGAMmjmIJdjp+Ez8duyn3ieo36yrttF5NSsJLAbxFpdlc1gvtGCWW+9Cq0b
dxviW8+TFVEBl1O4f7HVm6EpTscdDxU+bCXWkfjuRb7Dy9GOtt9JPsX8MBTakzh3
vBgsyi/sN3RqRBcGU40fOoZyfAMT8s1m/uYv52O6IgeuZ/ujbjY=
-----END RSA PRIVATE KEY-----

cd /directorio_temporal
touch id_rsa # Pegamos la clave
chmod 600 id_rsa
ssh -i id_rsa bandit17@localhots -p 2220

# Flag: EReVavePLFHtFlFsjn3hyzMlvSuSAcRD



# Bandit 17
sshpass -p 'EReVavePLFHtFlFsjn3hyzMlvSuSAcRD' ssh bandit17@bandit.labs.overthewire.org -p 2220

# El comando diff nos muestra la diferencia entre dos archivos, siendo el primero la linea que se suplanta y la segunda la linea que se ingresa
diff passwords.old passwords.new

42c42
< CgmS55GVlEKTgx8xpW8HuWnHlBKP924b
---
> x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO

# Flag: x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO



# Bandit 18
sshpass -p 'x2gLTTjFwMOhQ8oWNbMN362QKxfRqGlO' ssh bandit18@bandit.labs.overthewire.org -p 2220 bash
cat readme

# Flag: cGWpMaKXVwDUNgPAVJbWYuGHVn9zl3j8



# Bandit 19
sshpass -p 'cGWpMaKXVwDUNgPAVJbWYuGHVn9zl3j8' ssh bandit19@bandit.labs.overthewire.org -p 2220

./bandit20-do cat /etc/bandit_pass/bandit20

# Flag: 0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO



# Bandit 20
sshpass -p '0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO' ssh bandit20@bandit.labs.overthewire.org -p 2220

# Se abren dos terminales con las credenciales anteriores, en la primera nos ponemos en escucha con el siguiente comando
nc -nlvp <port> # 4646 en el ejemplo de savitar

# En la segunda terminal ejecutamos el script ./suconnect
./suconnect 4646

# En la primer ventana escribimos la contraseña del usuario 20
0qXahG8ZjOVMN9Ghs7iOWsCfZyXOUbYO

# Nos devuelve contraseña de bandit21

# Flag: EeoULMCra2q0dSkYj561DX7s1CpBuOBt



# Bandit 21
sshpass -p 'EeoULMCra2q0dSkYj561DX7s1CpBuOBt' ssh bandit21@bandit.labs.overthewire.org -p 2220
export TERM=xterm
ls -la /etc/cron.d/
drwxr-xr-x   2 root root  4096 Aug 15 13:19 .
drwxr-xr-x 128 root root 12288 Aug 15 13:19 ..
-r--r-----   1 root root    47 Aug 15 13:16 behemoth4_cleanup
-rw-r--r--   1 root root   123 Aug 15 13:09 clean_tmp
-rw-r--r--   1 root root   120 Aug 15 13:16 cronjob_bandit22
-rw-r--r--   1 root root   122 Aug 15 13:16 cronjob_bandit23
-rw-r--r--   1 root root   120 Aug 15 13:16 cronjob_bandit24
-rw-r--r--   1 root root   201 Apr  8  2024 e2scrub_all
-r--r-----   1 root root    48 Aug 15 13:17 leviathan5_cleanup
-rw-------   1 root root   138 Aug 15 13:17 manpage3_resetpw_job
-rwx------   1 root root    52 Aug 15 13:19 otw-tmp-dir
-rw-r--r--   1 root root   102 Mar 31  2024 .placeholder
-rw-r--r--   1 root root   396 Jan  9  2024 sysstat

cat /etc/cron.d/cronjob_bandit22
* * * * * bandit22 /usr/bin/cronjob_bandit22.sh &> /dev/null


cat /usr/bin/cronjob_bandit22.sh

#!/bin/bash
chmod 644 /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
cat /etc/bandit_pass/bandit22 > /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv

cat /tmp/t7O6lds9S0RqQh9aMcz6ShpAoZKF7fgv
tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q

# Flag: tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q



# Bandit 22
sshpass -p 'tRae0UfB9v0UzbCdn9cY0gQnds9GF58Q' ssh bandit22@bandit.labs.overthewire.org -p 2220

ls -la /etc/cron.d

-rw-r--r--   1 root root   122 Aug 15 13:16 cronjob_bandit23

cat /etc/cron.d/cronjob_bandit23

cat /usr/bin/cronjob_bandit23.sh

# Inicio de script
#!/bin/bash
myname=$(whoami)
mytarget=$(echo I am user $myname | md5sum | cut -d ' ' -f 1)
echo "Copying passwordfile /etc/bandit_pass/$myname to /tmp/$mytarget"
cat /etc/bandit_pass/$myname > /tmp/$mytarget
# FIn de script

echo "I am user bandit23" | md5sum | cut -d ' ' -f 1
8ca319486bfbbc3663ea0fbe81326349

cat /tmp/8ca319486bfbbc3663ea0fbe81326349

0Zf11ioIjMVN551jX3CmStKLYqjk54Ga

# Flag: 0Zf11ioIjMVN551jX3CmStKLYqjk54Ga



# Bandit 23
sshpass -p '0Zf11ioIjMVN551jX3CmStKLYqjk54Ga' ssh bandit23@bandit.labs.overthewire.org -p 2220

export TERM=xterm
ls -la /etc/cron.d | grep "bandit24"
-rw-r--r--   1 root root   120 Aug 15 13:16 cronjob_bandit24
cat /etc/cron.d/cronjob_bandit24

@reboot bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null
* * * * * bandit24 /usr/bin/cronjob_bandit24.sh &> /dev/null

cat /usr/bin/cronjob_bandit24.sh

#Inicio script
#!/bin/bash

myname=$(whoami)

cd /var/spool/$myname/foo
echo "Executing and deleting all scripts in /var/spool/$myname/foo:"
for i in * .*;
do
    if [ "$i" != "." -a "$i" != ".." ];
    then
        echo "Handling $i"
        owner="$(stat --format "%U" ./$i)"
        if [ "${owner}" = "bandit23" ]; then
            timeout -s 9 60 ./$i
        fi
        rm -f ./$i
    fi
done
#Fin script

mktemp -d
/tmp/tmp.eMtmAz5fCN
cd /tmp/tmp.eMtmAz5fCN
touch auto.sh
chmod +x auto.sh
chmod 777 /tmp/tmp.eMtmAz5fCN
nano auto.sh

#!/bin/bash
cat /etc/bandit_pass/bandit24 > passwd
cp passwd /tmp/tmp.1V03fbIWtJ

cp auto.sh /var/spool/bandit24/foo

# Esperamos un minuto
ls /tmp/tmp.1V03fbIWtJ
auto.sh  passwd
cat passwd
gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8

# Flag: gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8



# Bandit 24
sshpass -p 'gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8' ssh bandit24@bandit.labs.overthewire.org -p 2220

mktemp -d
cd /tmp/tmp.1234/

for pin in {0000..9999}; do echo gb8KRRCsshuZXI0tUuR6ypOFjiZbf3G8 $pin; done > combinations.txt

cat combinations.txt | nc localhost 30002 | grep -v "Wrong"

Correct!
The password of user bandit25 is iCi86ttT4KSNe1armKiwbQNmB3YJP3q4

# Flag: iCi86ttT4KSNe1armKiwbQNmB3YJP3q4



# Bandit 25
sshpass -p 'iCi86ttT4KSNe1armKiwbQNmB3YJP3q4' ssh bandit25@bandit.labs.overthewire.org -p 2220
# Hacer pequeña la pantalla en la que estamos operando
ssh -i bandit26.sshkey bandit26@localhost -p 2220

# En el modo more, presionar la letra v
# Presionamos esc
# Presionamos shift+:
:set shell=/bin/bash
# presionamos nuevamente shift+:
:shell # Esto nos da una shell, cuando entremos a more presionar q
ls
cat /etc/bandit_pass/bandit26
s0773xxkk0MXfdqOfPRVr9L3jJBUOgCZ
# Flag: s0773xxkk0MXfdqOfPRVr9L3jJBUOgCZ



# Bandit 26
sshpass -p 's0773xxkk0MXfdqOfPRVr9L3jJBUOgCZ' ssh bandit26@bandit.labs.overthewire.org -p 2220

./bandit27-do cat /etc/bandit_pass/bandit27
upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB

# Flag: upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB



# Bandit 27
sshpass -p 'upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB' ssh bandit27@bandit.labs.overthewire.org -p 2220

mktemp -d
cd temporal
git clone ssh://bandit27-git@localhost:2220/home/bandit27-git/repo
yes
upsNCc7vzaRDx6oZC6GiR6ERwe1MowGB
cd repo
The password to the next level is: Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN

# Flag: Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN



# Bandit 28
sshpass -p 'Yz9IpL0sBcCeuG7m9uQFt8ZNpS4HZRcN' ssh bandit28@bandit.labs.overthewire.org -p 2220

mktemp -d
cd temp

git clone ssh://bandit28-git@localhost:2220/home/bandit28-git/repo

git log

# Ver por actualizacion con parches de seguridad
git show 710c14a2e43cfd97041924403e00efb00b3a956e


commit 710c14a2e43cfd97041924403e00efb00b3a956e (HEAD -> master, origin/master, origin/HEAD)
Author: Morla Porla <morla@overthewire.org>
Date:   Fri Aug 15 13:16:10 2025 +0000

    fix info leak

diff --git a/README.md b/README.md
index d4e3b74..5c6457b 100644
--- a/README.md
+++ b/README.md
@@ -4,5 +4,5 @@ Some notes for level29 of bandit.
 ## credentials
 
 - username: bandit29
-- password: 4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7
+- password: xxxxxxxxxx

# Flag: 4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7




# Bandit 29
sshpass -p '4pT1t5DENaYuqnqvadYs1oE4QLCdjmJ7' ssh bandit29@bandit.labs.overthewire.org -p 2220

git clone ssh://bandit29-git@localhost:2220/home/bandit29-git/repo

git branch -a

* master
  remotes/origin/HEAD -> origin/master
  remotes/origin/dev
  remotes/origin/master
  remotes/origin/sploits-dev


git checkout dev

branch 'dev' set up to track 'origin/dev'.
Switched to a new branch 'dev'

ls
cat README.md

# Bandit Notes
Some notes for bandit30 of bandit.

## credentials

- username: bandit30
- password: qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL

# Flag: qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL



# Bandit 30
sshpass -p 'qp30ex3VLz5MDG1n91YowTv4Q8l7CDZL' ssh bandit30@bandit.labs.overthewire.org -p 2220


mktemp -d
cd temp
git clone ssh://bandit30-git@localhost:2220/home/bandit30-git/repo

git tag
secret

git show secret
fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy

# Flag: fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy



# Bandit 31
sshpass -p 'fb5S2xb7bRyFmAvQYQGEqsbhVyJqhnDy' ssh bandit31@bandit.labs.overthewire.org -p 2220

mktemp -d
cd temp

git clone ssh://bandit31-git@localhost:2220/home/bandit31-git/repo
cat README.md

This time your task is to push a file to the remote repository.

Details:
    File name: key.txt
    Content: 'May I come in?'
    Branch: master

bandit31@bandit:/tmp/tmp.nJzBFKuLtV/repo$ echo "May I come in?" > key.txt

bandit31@bandit:/tmp/tmp.nJzBFKuLtV/repo$ git add -f key.txt 
bandit31@bandit:/tmp/tmp.nJzBFKuLtV/repo$ git commit -m "Creamos un nuevo archivo"
[master d65bc48] Creamos un nuevo archivo
 1 file changed, 1 insertion(+)
 create mode 100644 key.txt

bandit31@bandit:/tmp/tmp.nJzBFKuLtV/repo$ git push -u origin master

bandit31-git@localhost's password: 
Enumerating objects: 4, done.
Counting objects: 100% (4/4), done.
Delta compression using up to 2 threads
Compressing objects: 100% (2/2), done.
Writing objects: 100% (3/3), 333 bytes | 333.00 KiB/s, done.
Total 3 (delta 0), reused 0 (delta 0), pack-reused 0
remote: ### Attempting to validate files... ####
remote: 
remote: .oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.
remote: 
remote: Well done! Here is the password for the next level:
remote: 3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K 
remote: 
remote: .oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.oOo.
remote: 
To ssh://localhost:2220/home/bandit31-git/repo
 ! [remote rejected] master -> master (pre-receive hook declined)
error: failed to push some refs to 'ssh://localhost:2220/home/bandit31-git/repo


# Flag: 3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K



# Bandit 32

# Volvemos al nivel anterior solo para ver la shell de este nivel

cat /etc/passwd | grep "bandit32"
bandit32:x:11032:11032:bandit level 32:/home/bandit32:/home/bandit32/uppershell

sshpass -p '3O9RfhqyAlVBEZpVb6LYStshZoqoSx5K' ssh bandit32@bandit.labs.overthewire.org -p 2220

$0

cd /home/bandit33
ls
cat README.txt

Congratulations on solving the last level of this game!

At this moment, there are no more levels to play in this game. However, we are constantly working
on new levels and will most likely expand this game with more levels soon.
Keep an eye out for an announcement on our usual communication channels!
In the meantime, you could play some of our other wargames.

If you have an idea for an awesome new level, please let us know!

```

## Proyectos de scripting en Bash

```bash

```

## Repaso personal de todo lo aprendido con Savitar ñ.ñ

Comandos

```bash
apt update # Para actualizar paquetes
apt list --upgradable # Lista paquetes que pueden actualizarse
parrot-upgrade # Para actualizar el S.O. Parrot
pwd # Nos muestra el directorio de trabajo
alias cat='batcat' # Nos cambia un comando por un alias que nosotros definamos, podemos definirlos tambien en archivo de configuracion de shell, bash=~/.bashrc, zsh=~/.zshrc
# --- Directorios
cd # Lo usamos para cambiar de directorios
cd ~ # Para regresar al directorio HOME del usuario /home/usuario
cd .. # Lo usamos para regresar al HOME /home
cd - # Lo usamos para movernos al directorio en el que estabamos
# --- Listar 
ls # Para enumerar todos los archivos y directorios visibles
ls -a # Para listar archivos y directorios, incluido los ocultos
ls -l # Forma de lista larga
ls -lh # Legible por humanos
ls -r # Lista en orden inverso
ls -S # Lista por tamaño
ls -t # Lista por tiempo de modificacion
# --- Busqueda
which cat # Nos devuelve la ruta del programa binario cat
whereis # Busca el manual binario, fuente y de usuario de un programa
find / -type -f -iname "*kitty*" # Busca desde la raiz un archivo ya sea en mayusculas o minusculas que incluya la palabra kitty.
!! # Para repetir el comando anterio ejecutado
touch nombreDeArchivo # Crea un archivo
cp /rutaOrigen /rutaDestino # Copiamos un archivo de un lugar a otro
mkdir nombreDelDirectorio # Creamos un directorio
rmdir nombreDelDirectorio # Borramos un directorio vacio
rm nombreDelArchivo # Borramos un archivo
rm -rf # Eliminamos un directorio de forma recursiva(usar con precaucion)
cat archivo # Vemos el interior de un archivo
cat -n archivo # Vemos el archivo con numeros de linea
cat archivo > /ruta/archivo # Copiamos la salida del archivo a una ruta
command -v which # Alternativa a which
echo $HOME # Muestra el directorio HOME del usuario
echo $PATH # Muestra las variables de entorno del usuario
echo $SHELL # Muestra el tipo de shell que usa el usuario
echo $? # Nos devuelve el codigo de estado del comando anterior ejecutado
whoami; ls # Ejecuta el primer comando y luego el segundo
whoami && ls # AND, se ejecuta el segundo comando solo si el primero devuelve un codigo de estado exitoso
whoami || ls # OR, En caso de que el primer comando no sea correcto ejecutará el segundo comando
wireshark & # El amperson hasta el final indica que deseo abrir cualquier aplicacion en segundo plano, me habilita un PID, pero sigo dependiendo de la terminal activa, ya que es un proceso hijo de esa instancia de terminal.
wireshark & disown # Lo mismo que el anterior solo que aquí ya no depende de la terminal
# --- CONTROL DE FLUJO STDERR STDOUT
error 2>/dev/null # Si el comando error tiene alguna salida con errores, esa salida redirigela al /dev/null
# Forma rara de usar el stdout
cat /etc/hosts > /dev/null # Todo la salida stdout y stderr se va al /dev/null sea correcto o no
cat /etc/host > /dev/null # Esto nos muestra el stderr
cat /etc/host > /dev/null 2>&1 # Convertimos el stderr en stdout y lo mandamos al dev/null
# Forma más comoda de usar el stdout hacia stderr
cat /etc/host &> /dev/null # De esta forma tanto el stderr como el stdout no se muestra en pantalla
wireshark # Lanza programa con interfaz grafica en primer plano y la CLI en segundo plano mandando stdout
wireshark &> /dev/null # Lanza la herramienta sin reportar nada por CLI
remmina &>/dev/null & disown # Lanza remmina sin reportar nada por CLI en segundo plano sin que dependa de la terminal, crea un PID
chmod # Cambiar permisos de archivos y directorios, u,g,o, user, group, others. r,w,x.
chmod u+s /ruta/archivo # Damos permiso SUID
chmod g+s /carpetaCompartida # Damos permiso a carpeta compartida con permiso SGID
chmod o+t /tmp # Damos permiso de sticky a carpeta temporal
chgrp valor1 valor2 # valor1=grupo valor2=directorio, asigno al grupo valor1 el directorio valor2
useradd gerardo -s /bin/bash -d /home/gerardo # Creamos el usuario Gerardo, le asignamos como shell una bash y le asignamos su directorio home de trabajo
chown # valor1=propietario valor2=directorio, asigno a valor1 el directorio valor2
chown propietario:grupo directorio # Para cambiar permisos en una linea
passwd gerardo # Nos pedirá escribir la contraseña del usuario gerardo
groupadd nombreGrupo # Creamos el grupo nombreGrupo
usermod -a -G valor1 valor2 # Añadimos al usuario valor2 al grupo valor1
sudo gpasswd -d valor1 valor2 # Eliminamos al usuario valor1 del grupo valor2
sudo usermod -G valor1 valor2 # Eliminamos el usuario valor2 del grupo valor1
userdel -f # Esta opcion fuerza la eliminacion de la cuenta
sudo userdel -r valor1 # Eliminamos al usuario valor1 del sistema, borra directorio home de usuario, todo con respecto al usuario.
find / -type -f -perm -4000 2> /dev/null # Busca archivos con privilegios SUID y mandamos el error al dev null
find / -type -f -perm -2000 2> /dev/null # Busca archivos con privilegios SGID y mandamos el error al dev null

```

Atajos

```bash
ctrl + l # Limpiamos terminal
```

Rutas interesantes

```bash
cat /etc/passwd # Archivo donde estan los directorios personales de usuarios
cat /etc/shells # Muestra las shells existentes en el equipo
cat /etc/hosts # Nos muestra direcciones IP
cat /etc/shadow # Tiene las contraseñas encriptadas
cat /etc/login.defs | grep "ENCRYPT_METHOD"
```

---

### Utilerias

* Instalar cat mejorado -> batcat
  * Modificar archivo .bashrc
    * alias bc='batcat'
* Instalar cat mejorado -> lsd
  * Modificar archivo .bashrc
    * alias ls='lsd'
* Personalizar la terminal -> PowerLevel10k
* Recargar terminal -> source ~/.bashrc
* Instalar y aprender a usar la kitty

---

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
