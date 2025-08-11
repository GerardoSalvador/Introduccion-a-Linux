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

### Utilerias

* cat -> batcat
* ls -> lsd
* powerlevel10k -> para personalizar la terminal
