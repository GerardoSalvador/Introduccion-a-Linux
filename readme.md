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
  * El bit setuid es asignable a ficheros ejecutables, y permite que cuando un usuario ejecute dicho fichero, el proceso adquiera los permisos del propietario del fichero ejecutado. El ejemplo más claro de fichero ejecutable y con el bit setuid es:
* Permiso SGID (Set Group ID)
* Permiso de persistencia (Sticky Bit)

[Permisos básicos en Linux](https://www.profesionalreview.com/2017/01/28/permisos-basicos-linux-ubuntu-chmod/)

### Lectura e interpretación de permisos [2-2]

### Utilerias

* Instalar cat mejorado -> batcat
  * Modificar archivo .bashrc
    * alias bc='batcat'
* Instalar cat mejorado -> lsd
  * Modificar archivo .bashrc
    * alias ls='lsd'
* Personalizar la terminal -> PowerLevel10k
* Recargar terminal -> source ~/.bashrc
