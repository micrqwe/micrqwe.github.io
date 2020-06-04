可选参数：
```
    keep_first_letter启用此选项时，例如：刘德华> ldh，默认值：true
    keep_separate_first_letter启用该选项时，将保留第一个字母分开，例如：刘德华> l，d，h，默认：假的，注意：查询结果也许是太模糊，由于长期过频
    limit_first_letter_length 设置first_letter结果的最大长度，默认值：16
    keep_full_pinyin当启用该选项，例如：刘德华> [ liu，de，hua]，默认值：true
    keep_joined_full_pinyin当启用此选项时，例如：刘德华> [ liudehua]，默认值：false
    keep_none_chinese 在结果中保留非中文字母或数字，默认值：true
    keep_none_chinese_together保持非中国信一起，默认值：true，如：DJ音乐家- > DJ，yin，yue，jia，当设置为false，例如：DJ音乐家- > D，J，yin，yue，jia，注意：keep_none_chinese必须先启动
    keep_none_chinese_in_first_letter第一个字母保持非中文字母，例如：刘德华AT2016- > ldhat2016，默认值：true
    keep_none_chinese_in_joined_full_pinyin保留非中文字母加入完整拼音，例如：刘德华2016- > liudehua2016，默认：false
    none_chinese_pinyin_tokenize打破非中国信成单独的拼音项，如果他们拼音，默认值：true，如：liudehuaalibaba13zhuanghan- > liu，de，hua，a，li，ba，ba，13，zhuang，han，注意：keep_none_chinese和keep_none_chinese_together应首先启用
    keep_original 当启用此选项时，也会保留原始输入，默认值：false
    lowercase 小写非中文字母，默认值：true
    trim_whitespace 默认值：true
    remove_duplicated_term当启用此选项时，将删除重复项以保存索引，例如：de的> de，默认值：false，注意：位置相关查询可能受影响
```