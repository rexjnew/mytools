
// 2022-04-03 笔记

//1. 读写数据
bytes = make([]byte, 1024)
reader.Read(bytes)

bytes, err := ioutil.ReadAll(reader)  //读所有数据

str := “My String Data”
reader := strings.NewReader(str)

bytes = []byte("Hello World")
writer.Write(bytes)

var buf bytes.Buffer
fmt.Fprintf(&buf, "Hello %s", "World")
s := buf.String() // s == "Hello World"

//2. 读写文件

data := []byte("Hello World!\n")
// Write
ioutil.WriteFile("data1", data, 0644)
// Read
read1, _ := ioutil.ReadFile("data1")
fmt.Print(string(read1)) // Hello World!

// Create the file
file1, _ := os.Create("data2")
defer file1.Close()
//Write 
bytes, _ := file1.Write(data)
fmt.Printf("Wrote %d bytes to file\n", bytes)
// Opening the file
file2, _ := os.Open("data2")
defer file2.Close()
// Read
read2 := make([]byte, len(data))
bytes, _ = file2.Read(read2)
fmt.Printf("Read %d bytes from file\n", bytes)
fmt.Println(string(read2))




file, err := os.OpenFile(filename, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
datawriter := bufio.NewWriter(file)
datawriter.WriteString(fieldname)
datawriter.Flush()
file.Close()

file, err := os.OpenFile("/tmp/123.txt", os.O_WRONLY|os.O_CREATE|os.O_APPEND, 0600)
defer f.Close()
n, err := file.Write([]byte("writing some data into a file"))


file, err := os.Open(path)
defer file.Close()
scanner := bufio.NewScanner(file)
for scanner.Scan() {
 fmt.Println( scanner.Text())
}


/*
Go中的指针及与指针对指针的操作主要有以下三种：
一普通的指针类型，例如 var intptr *T，定义一个T类型指针变量。

二内置类型uintptr，本质是一个无符号的整型，它的长度是跟平台相关的，它的长度可以用来保存一个指针地址。

三是unsafe包提供的Pointer，表示可以指向任意类型的指针
*/
