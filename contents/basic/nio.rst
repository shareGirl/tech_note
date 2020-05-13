NIO
################################################################

Java NIO 简介
****************************************************************

Java NIO(New IO)是从Java 1.4版本开始引入的 一个新的IO API，可以替代标准的Java IO API。 NIO与原来的IO有同样的作用和目的，但是使用 的方式完全不同，NIO支持 面向缓冲区的、基于 通道的IO操作。NIO将以更加高效的方式进行文件的读写操作。

Java NIO和 IO的主要区别
****************************************************************

|image0|

|image1|

通道和缓冲区
================================================================

| Java NIO系统的核心在于:通道(Channel)和缓冲区 (Buffer)。通道表示打开到 IO 设备(例如:文件、 套接字)的连接。若需要使用 NIO 系统，需要获取用于连接 IO 设备的通道以及用于容纳数据的缓冲区。然后操作缓冲区，对数据进行处理。
| 简而言之，Channel 负责传输， Buffer 负责存储

缓冲区
================================================================

* 缓冲区（Buffer） ：一个用于特定基本数据类型的容器。由 java.nio 包定义的，所有缓冲区都是 Buffer 抽象类的子类。
* Java NIO 中的 Buffer 主要用于与 NIO 通道进行交互，数据是从通道读入缓冲区，从缓冲区写入通道中的。

缓冲区(Buffer)的数据存取
****************************************************************

::

	/**
	 * 一. 缓冲区(Buffer): 在 Java NIO 中负责数据的存取; 缓冲区就是数组，用于存储不同数据类型的数据
	 * 根据数据类型不同(boolean 除外)，提供不同类型的缓存区
	 * ByteBuffer
	 * CharBuffer
	 * ShortBuffer
	 * IntBuffer
	 * LongBuffer
	 * FloatBuffer
	 * DoubleBuffer
	 *
	 * 上述缓存区管理方式几乎一致,通过 allocate() 获取缓冲区
	 *
	 * 二. 缓冲区存取数据的两个核心方法:
	 * put(): 存入数据到缓冲区
	 * get(): 获取缓冲区中数据
	 *
	 * 三. 缓冲器中的四个核心属性
	 * capacity: 容量，表示缓存区中最大存储数据的容量，一旦定义不能修改
	 * limit: 界限,表示缓冲区中可以操作数据的大小(limit 后数据不能进行读写)
	 * position: 表示换洪武正在操作数据的位置
	 * mark: 标记，表示记录当前 position 的位置，可以通过 reset()
	 *
	 * 0 < = mark <= position <= limit <= capacity
	 */
	public class TestBuffer {

	    @Test
	    public void test2() {
	        String str = "abcde";

	        ByteBuffer buf = ByteBuffer.allocate(1024);
	        buf.put(str.getBytes());

	        buf.flip();

	        byte[] dst = new byte[buf.limit()];
	        buf.get(dst, 0, 2);
	        System.out.println(new String(dst, 0 ,2));

	        System.out.println(buf.position());

	        //mark(): 标记
	        buf.mark();

	        buf.get(dst, 2, 2);
	        System.out.println(new String(dst, 2, 2));
	        System.out.println(buf.position());

	        //reset(): 恢复到 mark 的位置
	        buf.reset();

	        System.out.println(buf.position());

	        //判断缓冲区中是否还有剩余的数据
	        if (buf.hasRemaining()) {
	            //获取缓冲区中可以操作的数量
	            System.out.println(buf.remaining());
	        }
	    }

	    @Test
	    public void test1() {
	        String str = "abcde";

	        //1 分配指定大小的缓冲区
	        ByteBuffer buf = ByteBuffer.allocate(1024);

	        System.out.println(buf.position());   //0
	        System.out.println(buf.limit());      //1024
	        System.out.println(buf.capacity());   //1024

	        System.out.println("===================");

	        //2 利用 put() 存入数据到缓冲区中
	        buf.put(str.getBytes());
	        System.out.println(buf.position());     //5
	        System.out.println(buf.limit());        //1024
	        System.out.println(buf.capacity());     //1024

	        System.out.println("===================");

	        //3 切换读取数据模式
	        buf.flip();
	        System.out.println(buf.position());     //0
	        System.out.println(buf.limit());        //5
	        System.out.println(buf.capacity());     //1024

	        System.out.println("===================");

	        //4 利用 get() 方法读取数据
	        byte[] dst = new byte[buf.limit()];
	        buf.get(dst);
	        System.out.println(new String(dst, 0, dst.length));

	        System.out.println(buf.position());        //5
	        System.out.println(buf.limit());            //5
	        System.out.println(buf.capacity());         //1024

	        System.out.println("===================");

	        //5 rewind() 可重复读数据
	        buf.rewind();
	        System.out.println(buf.position());         //0
	        System.out.println(buf.limit());            //5
	        System.out.println(buf.capacity());         //1024

	        System.out.println("===================");

	        //6 clear(): 清空缓冲区 但缓冲区中数据还在，处于"被遗忘的状态"
	        System.out.println(buf.position());         //0
	        System.out.println(buf.limit());            //1024
	        System.out.println(buf.capacity());         //1024

	        System.out.println((char)buf.get());
	    }
	}

直接缓冲区与非直接缓冲区
****************************************************************

* 非直接缓存区: 通过 allocate() 方法分配缓冲区,将缓冲区建立在 JVM 的内存中
* 直接缓存区: 通过 allocateDirect() 方法分配直接缓存区, 将缓冲区建立在物理内存中.可以提高效率

::

	@Test
	public void test3() {
	    //分配直接缓冲区
	    ByteBuffer buf = ByteBuffer.allocateDirect(1024);
	    System.out.println(buf.isDirect());
	}

非直接缓冲区
================================================================

|image3|

直接缓冲区
================================================================

|image4|

通道(Channel)的原理与获取
****************************************************************

通道
================================================================

| 通道(Channel):由 java.nio.channels 包定义的。Channel 表示 IO 源与目标打开的连接。
| Channel 类似于传统的“流”。只不过 Channel本身不能直接访问数据,Channel 只能与Buffer 进行交互。

DMA(Direct Memory Access，直接存储器访问) 是所有现代电脑的重要特色，它允许不同速度的硬件装置来沟通，而不需要依赖于 CPU 的大量中断负载。否则，CPU 需要从来源把每一片段的资料复制到暂存器，然后把它们再次写回到新的地方。在这个时间中，CPU 对于其他的工作来说就无法使用。

早期的处理模式，比较耗费 CPU。 如下:

|image5|

优化的处理模式，使用 DMA 。如下:

|image6|

大量的请求会造成 DMA 总线拥塞。使用 通道 替代 DMA, 如下:

|image7|                                                                                             

通道的数据传输与内存映射文件
****************************************************************

::

	一. 通道(Channel): 用于源节点与目标节点的连接。在 Java NIO 中负责缓冲区中的数据的传输。Channel 本身不存储数据，因此需要配合配合缓冲器进行传输                                               
	                                                                                                                                     
	二.通道的主要实现类                                                                                                                           
		java.nio.channels.Channel接口:                                                                                                         
		 |--FileChannel                                                                                                                      
		 |--SocketChannel                                                                                                                    
		 |--ServerSocketChannel                                                                                                              
		 |--DatagramChannel                                                                                                                  
		                                                                                                                                     
	三.获取通道                                                                                                                               
		1.java 针对支持通道的类提供了getChannel()方法                                                                                                     
		     本地IO:                                                                                                                           
		         FileInputStream/FileOutputStream                                                                                            
		         RandomAccessFile                                                                                                            
		     网络IO                                                                                                                            
		         Socket                                                                                                                      
		         ServerSocket                                                                                                                
		         DatagramSocket                                                                                                              
		2. 1.7 中的 NIO.2 针对各个通道提供了静态方法open()                                                                                                  
		3. 1.7 中的 NIO.2, Files 工具类的newByteChannel  
		 
	四. 通道之间的数据传输       
	 transferFrom()    
	 transfrtTo()  

利用通道完成文件的复制(非直接缓存中) 
================================================================

::

    public void test1() throws Exception {
        FileInputStream fis = null;
        FileOutputStream fos = null;
        FileChannel inChannel = null;
        FileChannel outChannel = null;
        try {
            fis = new FileInputStream("/Users/lilizhao/my_source/LearningDemo/java_basic/src/main/java/com/llz/nio/TestChannel.java");
            fos = new FileOutputStream("/Users/lilizhao/my_source/LearningDemo/java_basic/target/2.txt");

            //1) 获取通道
            inChannel = fis.getChannel();
            outChannel = fos.getChannel();

            //2) 分配指定大小的缓冲区
            ByteBuffer buf = ByteBuffer.allocate(1024);

            //3) 将通道中的数据存入缓冲区中
            while (inChannel.read(buf) != -1) {
                buf.flip();
                //4) 将通道中的数据存入缓冲区中
                outChannel.write(buf);

                buf.clear();
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (outChannel != null) {
                outChannel.close();
            }

            if (inChannel != null) {
                inChannel.close();
            }

            if (fos != null) {
                fos.close();
            }

            if (fis != null) {
                fis.close();
            }
        }
    }

使用直接缓冲区(内存映射文件的方式)完成文件的复制
================================================================

::

    @Test
    public void test2() throws IOException {
        FileChannel inChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/src/main/java/com/llz/nio/TestChannel.java"),
                StandardOpenOption.READ);
        FileChannel outChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/target/3.txt"),
                StandardOpenOption.WRITE, StandardOpenOption.READ, StandardOpenOption.CREATE_NEW);

        //内存映射文件 --> 直接放入文件中 直接操作缓冲区
        MappedByteBuffer inMapperBuf = inChannel.map(FileChannel.MapMode.READ_ONLY, 0, inChannel.size());
        MappedByteBuffer outMapperBuf = outChannel.map(FileChannel.MapMode.READ_WRITE, 0, inChannel.size());

        //直接对缓冲区进行数据的读写操作
        byte[] dst = new byte[inMapperBuf.limit()];
        inMapperBuf.get(dst);
        outMapperBuf.put(dst);

        inChannel.close();
        outChannel.close();
    }

使用直接缓冲区(内存映射文件的方式)完成文件的复制
================================================================

::

	@Test
	public void test2() throws IOException {
	    FileChannel inChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/src/main/java/com/llz/nio/TestChannel.java"),
	            StandardOpenOption.READ);
	    FileChannel outChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/target/3.txt"),
	            StandardOpenOption.WRITE, StandardOpenOption.READ, StandardOpenOption.CREATE_NEW);

	    //内存映射文件 --> 直接放入文件中 直接操作缓冲区
	    MappedByteBuffer inMapperBuf = inChannel.map(FileChannel.MapMode.READ_ONLY, 0, inChannel.size());
	    MappedByteBuffer outMapperBuf = outChannel.map(FileChannel.MapMode.READ_WRITE, 0, inChannel.size());

	    //直接对缓冲区进行数据的读写操作
	    byte[] dst = new byte[inMapperBuf.limit()];
	    inMapperBuf.get(dst);
	    outMapperBuf.put(dst);

	    inChannel.close();
	    outChannel.close();
	}

通道之间的数据传输(直接缓冲区的方式)
================================================================

::

	@Test
	public void test3() throws IOException {
	    FileChannel inChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/src/main/java/com/llz/nio/TestChannel.java"),
	            StandardOpenOption.READ);
	    FileChannel outChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/target/4.txt"),
	            StandardOpenOption.WRITE, StandardOpenOption.READ, StandardOpenOption.CREATE_NEW);

	  //inChannel.transferTo(0, inChannel.size(), outChannel);
	    outChannel.transferFrom(inChannel, 0, inChannel.size());
	            
	    inChannel.close();
	    outChannel.close();
	}

分散读取与聚集写入
****************************************************************

* 分散是将一个Channel中的数据写到多个顺序的buffer中，一般是传进一个buffer数组中，Channel中的数据依次写入buffer数组中的buffer当中。

|image8| 

* 聚集是将多个buffer中的数据写入同一个Channel中，一般操作是一个buffer数组。

|image9|

::

	@Test
	public void test5() throws IOException {
	    FileInputStream fis = new FileInputStream("d:\\1.txt");
	    FileChannel inputChannel = fis.getChannel();
	    FileOutputStream fos = new FileOutputStream("d:\\1.bak.txt");
	    FileChannel outputChannel = fos.getChannel();

	    ByteBuffer buf1 = ByteBuffer.allocate(1024);
	    ByteBuffer buf2 = ByteBuffer.allocate(64);
	    ByteBuffer buf3 = ByteBuffer.allocate(32);
	    ByteBuffer[] bufs = { buf1, buf2, buf3 };

	    while (inputChannel.read(bufs) != -1) {
	        // 分散读取（Scattering Reads）
	        inputChannel.read(bufs);

	        for (ByteBuffer buf : bufs) {
	            buf.flip();
	        }
	        // 聚集写入（Gathering Writes）
	        outputChannel.write(bufs);

	        for (ByteBuffer buf : bufs) {
	            buf.clear();
	        }
	    }
	}

字符集 Charset
****************************************************************

::

	@Test
	public void test6(){
	    try {
	        Charset gbk = Charset.forName("GBK");
	        //获取编码器
	        CharsetEncoder charsetEncoder = gbk.newEncoder();
	        //获取解码器
	        CharsetDecoder charsetDecoder = gbk.newDecoder();

	        CharBuffer charBuffer = CharBuffer.allocate(1024);
	        charBuffer.put("中国");
	        charBuffer.flip();

	        //编码  解出来的bytebuffer已经是 切换成读模式了  不用在切换
	        ByteBuffer byteBuffer = charsetEncoder.encode(charBuffer);
	        //解码 解出来的CharBuffer已经是 切换成读模式了  不用在切换
	        CharBuffer decode = charsetDecoder.decode(byteBuffer);
	        System.out.println(decode.toString());

	        System.out.println("==================================");

	        //编码
	        Charset utf8 = Charset.forName("UTF-8");

	        byteBuffer.flip();
	        CharBuffer utf8Decode = utf8.decode(byteBuffer);
	        System.out.println(utf8Decode);
	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	    }
	}

阻塞非阻塞与同步异步的区别(番外篇)
****************************************************************

* 同步与异步

::

	同步和异步关注的是消息通信机制 (synchronous communication/ asynchronous communication)
	所谓同步，就是在发出一个*调用*时，在没有得到结果之前，该*调用*就不返回。但是一旦调用返回，就得到返回值了。
	换句话说，就是由*调用者*主动等待这个*调用*的结果。
	而异步则是相反，*调用*在发出之后，这个调用就直接返回了，所以没有返回结果。换句话说，当一个异步过程调用发出后，调用者不会立刻得到结果。而是在*调用*发出后，*被调用者*通过状态、通知来通知调用者，或通过回调函数处理这个调用。
	
	典型的异步编程模型比如Node.js
	
	举个通俗的例子：
	你打电话问书店老板有没有《分布式系统》这本书，如果是同步通信机制，书店老板会说，你稍等，”我查一下"，然后开始查啊查，等查好了（可能是5秒，也可能是一天）告诉你结果（返回结果）。
	而异步通信机制，书店老板直接告诉你我查一下啊，查好了打电话给你，然后直接挂电话了（不返回结果）。然后查好了，他会主动打电话给你。在这里老板通过“回电”这种方式来回调。

* 阻塞与非阻塞

::

	阻塞和非阻塞关注的是程序在等待调用结果（消息，返回值）时的状态.
	阻塞调用是指调用结果返回之前，当前线程会被挂起。调用线程只有在得到结果之后才会返回。
	非阻塞调用指在不能立刻得到结果之前，该调用不会阻塞当前线程。

	还是上面的例子，
	你打电话问书店老板有没有《分布式系统》这本书，你如果是阻塞式调用，你会一直把自己“挂起”，直到得到这本书有没有的结果，如果是非阻塞式调用，你不管老板有没有告诉你，你自己先一边去玩了， 当然你也要偶尔过几分钟check一下老板有没有返回结果。
	在这里阻塞与非阻塞与是否同步异步无关。跟老板通过什么方式回答你结果无关。

* 实例

::

	老张爱喝茶，废话不说，煮开水。
	出场人物：老张，水壶两把（普通水壶，简称水壶；会响的水壶，简称响水壶）。
	1 老张把水壶放到火上，立等水开。（同步阻塞）
	老张觉得自己有点傻
	2 老张把水壶放到火上，去客厅看电视，时不时去厨房看看水开没有。（同步非阻塞）
	老张还是觉得自己有点傻，于是变高端了，买了把会响笛的那种水壶。水开之后，能大声发出嘀~~~~的噪音。
	3 老张把响水壶放到火上，立等水开。（异步阻塞）
	老张觉得这样傻等意义不大
	4 老张把响水壶放到火上，去客厅看电视，水壶响之前不再去看它了，响了再去拿壶。（异步非阻塞）
	老张觉得自己聪明了。
	所谓同步异步，只是对于水壶而言。
	普通水壶，同步；响水壶，异步。
	虽然都能干活，但响水壶可以在自己完工之后，提示老张水开了。这是普通水壶所不能及的。
	同步只能让调用者去轮询自己（情况2中），造成老张效率的低下。
	所谓阻塞非阻塞，仅仅对于老张而言。
	立等的老张，阻塞；看电视的老张，非阻塞。
	情况1和情况3中老张就是阻塞的，媳妇喊他都不知道。虽然3中响水壶是异步的，可对于立等的老张没有太大的意义。所以一般异步是配合非阻塞使用的，这样才能发挥异步的效用。

	同步和异步仅仅是关于所关注的消息如何通知的机制。同步的情况下,是由处理消息者自己去等待消息是否被触发,而异步的情况下是由触发机制来通知处理消息者
	阻塞和非阻塞应该是发生在消息的处理的时刻。阻塞其实就是等待，发出通知，等待结果完成。非阻塞属于发出通知，立即返回结果，没有等待过程。


阻塞式实例
****************************************************************

::

	@Test
	public void testClient() throws IOException {
	    //获取通道
	    SocketChannel socketChannel = SocketChannel.open(new InetSocketAddress("127.0.0.1", 9898));

	    //获取读通道
	    FileChannel inChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/src/main/java/com/llz/nio/TestBlockingNIO.java"), StandardOpenOption.READ);

	    //2.分配缓冲区大小
	    ByteBuffer byteBuffer = ByteBuffer.allocate(1024);
	    //读取本地文件，并发送到服务端
	    while(inChannel.read(byteBuffer)!=-1){
	        //切换到读模式
	        byteBuffer.flip();
	        //写入到网络通道中
	        socketChannel.write(byteBuffer);
	        //清空缓存区
	        byteBuffer.clear();
	    }

	    //关闭通道
	    inChannel.close();
	    socketChannel.close();

	}

	//服务端--接收客户端发送的数据，并写入到指定的路径中
	@Test
	public void testServer() throws IOException {
	    //获取服务端通道
	    ServerSocketChannel ssChannel = ServerSocketChannel.open();

	    //创建写入的通道
	    FileChannel outChannel = FileChannel.open(Paths.get("/Users/lilizhao/my_source/LearningDemo/java_basic/target/11.txt"), StandardOpenOption.WRITE, StandardOpenOption.CREATE);

	    //根据 客户端端口号，获取连接
	    ssChannel.bind(new InetSocketAddress(9898));
	    //获取客户端的连接通道
	    SocketChannel socketChannel = ssChannel.accept();

	    //分配指定大小的缓冲区
	    ByteBuffer byteBuffer = ByteBuffer.allocate(1024);

	    //读取客户端发送的数据，并写入到指定路径下
	    while(socketChannel.read(byteBuffer)!=-1){
	        //切换模式
	        byteBuffer.flip();
	        outChannel.write(byteBuffer);
	        byteBuffer.clear();
	    }
	    
	    //关闭通道
	    socketChannel.close();
	    outChannel.close();
	    ssChannel.close();
	}

非阻塞式实例
****************************************************************

::

	//客户端
	@Test
	public void client() throws IOException {
	    //1.获取通道
	    SocketChannel sChannel = SocketChannel.open(new InetSocketAddress("127.0.0.1", 9898));

	    //2.切换非阻塞模式
	    sChannel.configureBlocking(false);

	    //3.分配指定大小的缓冲区
	    ByteBuffer buf = ByteBuffer.allocate(1024);

	    //4.发送数据给服务端
	    buf.put(new Date().toString().getBytes());
	    buf.flip();
	    sChannel.write(buf);
	    buf.clear();

	    //5.关闭通道
	    sChannel.close();
	}

	//服务端
	@Test
	public void server() throws IOException {
	    //1.获取通道
	    ServerSocketChannel ssChannel = ServerSocketChannel.open();

	    //2.切换非阻塞模式
	    ssChannel.configureBlocking(false);

	    //3.绑定链接
	    ssChannel.bind(new InetSocketAddress(9898));

	    //4.获取选择器
	    Selector selector = Selector.open();

	    //5.将通道注册到选择器,并且制定"接收事件"
	    ssChannel.register(selector, SelectionKey.OP_ACCEPT);//非阻塞式

	    //6.轮询式的获取选择器上已经“准备就绪”的事件
	    while (selector.select() > 0) {
	        //7.获取当前选择器中所有注册的“选择键（已就绪的监听事件）”
	        Iterator<SelectionKey> it = selector.selectedKeys().iterator();

	        while (it.hasNext()) {
	            //8.获取准备“就绪”的事件
	            SelectionKey sk = it.next();

	            //9.判断具体是什么事件准备就绪
	            if (sk.isAcceptable()) {
	                //10.若”接收就绪“，获取客户端链接
	                SocketChannel sChannel = ssChannel.accept();

	                //11.切换非阻塞模式
	                sChannel.configureBlocking(false);

	                //12.将该通道注册到选择器上
	                sChannel.register(selector, SelectionKey.OP_READ);

	            } else if (sk.isReadable()) {
	                //13.获取当前选择器上“该就绪”状态的通道
	                SocketChannel sChannel = (SocketChannel) sk.channel();

	                //14.读取数据
	                ByteBuffer buf = ByteBuffer.allocate(1024);

	                int len = 0;
	                while ((len = sChannel.read(buf)) > 0) {
	                    buf.flip();
	                    System.out.println(new String(buf.array(), 0, len));
	                    buf.clear();
	                }
	            }

	            //15.取消选择键SelectionKey
	            it.remove();

	        }
	    }
	}

DatagramChannel
****************************************************************

::

	@Test
	public void send() throws IOException{
	    DatagramChannel dc = DatagramChannel.open();
	    
	    dc.configureBlocking(false);
	    
	    ByteBuffer buf = ByteBuffer.allocate(1024);
	    
	    Scanner scan = new Scanner(System.in);
	    
	    while(scan.hasNext()){
	        String str = scan.next();
	        buf.put((new Date().toString() + ":\n" + str).getBytes());
	        buf.flip();
	        dc.send(buf, new InetSocketAddress("127.0.0.1", 9898));
	        buf.clear();
	    }
	    
	    dc.close();
	}

	@Test
	public void receive() throws IOException{
	    DatagramChannel dc = DatagramChannel.open();
	    
	    dc.configureBlocking(false);
	    
	    dc.bind(new InetSocketAddress(9898));
	    
	    Selector selector = Selector.open();
	    
	    dc.register(selector, SelectionKey.OP_READ);
	    
	    while(selector.select() > 0){
	        Iterator<SelectionKey> it = selector.selectedKeys().iterator();
	        
	        while(it.hasNext()){
	            SelectionKey sk = it.next();
	            
	            if(sk.isReadable()){
	                ByteBuffer buf = ByteBuffer.allocate(1024);
	                
	                dc.receive(buf);
	                buf.flip();
	                System.out.println(new String(buf.array(), 0, buf.limit()));
	                buf.clear();
	            }
	        }
	        
	        it.remove();
	    }
	}

Pipe 管道
****************************************************************

Java NIO 管道是2个线程之间的单向数据连接。Pipe有一个source通道和一个sink通道。数据会被写到sink通道，从source通道读取。

|image10|

::

	@Test
	public void test1() throws IOException {
	    //1. 获取管道
	    Pipe pipe = Pipe.open();

	    //2. 将缓冲区中的数据写入管道
	    ByteBuffer buf = ByteBuffer.allocate(1024);

	    Pipe.SinkChannel sinkChannel = pipe.sink();
	    buf.put("通过单向管道发送数据".getBytes());
	    buf.flip();
	    sinkChannel.write(buf);

	    //3. 读取缓冲区中的数据
	    Pipe.SourceChannel sourceChannel = pipe.source();
	    buf.flip();
	    int len = sourceChannel.read(buf);
	    System.out.println(new String(buf.array(), 0, len));

	    sourceChannel.close();
	    sinkChannel.close();
	}

.. tip::

	参考资料: https://www.cnblogs.com/biaogejiushibiao/p/10468578.html#_label2
	参考资料: https://blog.csdn.net/weixin_30881367/article/details/99871056

.. |image0| image:: /_static/java_basic/WX20200409-114449@2x.webp
.. |image1| image:: /_static/java_basic/WX20200409-114856@2x.webp
.. |image2| image:: /_static/java_basic/20170306220636876.png
.. |image3| image:: /_static/java_basic/1399348-20190307170538300-526079808.png
.. |image4| image:: /_static/java_basic/1399348-20190307170606378-1845737285.png
.. |image5| image:: /_static/java_basic/1399348-20190307170645151-1010535176.png
.. |image6| image:: /_static/java_basic/1399348-20190307170705856-402896977.png
.. |image7| image:: /_static/java_basic/1399348-20190307170717197-955469462.png
.. |image8| image:: /_static/java_basic/1072224-20170315205324838-677611801.png
.. |image9| image:: /_static/java_basic/1072224-20170315205505495-105754400.png
.. |image10| image:: /_static/java_basic/401339-20180103223716471-1548460371.png
















































