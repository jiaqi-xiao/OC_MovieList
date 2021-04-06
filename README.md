# OC_MovieList

## Demo 展示

![IMG_0004](/Users/xiaojiaqi03/Kwai/Playground/OC_MovieList/README.assets/IMG_0004.PNG)

## Demo要求

- 根据[电影列表](https://api.androidhive.info/json/movies.json)展示所有电影的海报图和电影名称
- 使用异步方式加载图片确保流畅性
- 使用缓存对图片加载进行优化
- 不使用第三方库，均采用原生方法

## 整体思路

整个列表的内容都利用Navigation Controller中的Table View呈现。首先在TableViewController中通过异步请求得到电影列表的JSON文件，并通过序列化将JSON文件转存入我们自定义的MovieDataModel数组中。在更新TableView中的每一个Cell时，调用ImageDownloader，首先尝试读取缓存，如果不存在，对图片进行异步下载，下载后加载入缓存，reloadData重新加载。