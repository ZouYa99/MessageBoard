# MessageBoard

### 已实现功能

* 当消息数量很少的时候，**优先铺满底部区域**而非顶部区域
* 新的消息在底部，老的消息在顶部
* 支持富文本
* 支持多种消息 
  * 普通富文本
  * 系统富文本
  * 图片消息
  * 语音消息

* 做一个输入框
* 获取消息的方式
  * 硬编码
  * 增加 json 反序列化功能
  * 增加读取本地文件功能（json格式）

* 比如如果我们在看上面的消息，而后面来了新消息，则显示 有xx条新消息

### 未实现

- 应当考虑消息量大的时候的优化 
- 增加本地数据库 永久化数据
- 视频消息
- 头部可以考虑增加 icon 等各种花里胡哨的
- 支持网络方式获取消息
- 比如聊天室里来了新的人可以显示 xx来了