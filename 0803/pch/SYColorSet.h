//
//  SYColorSet.h
//  shengYunEmployee
//
//  Created by dqh on 17/2/20.
//  Copyright © 2017年 dqh. All rights reserved.
//

#ifndef SYColorSet_h
#define SYColorSet_h

//|--------------------------
//主颜色
#define SY_MainColorName @"#ff3131"
#define SY_MainColor colorWithHex(SY_MainColorName)



/**
 主颜色

 @return 主颜色
 */
#define SY_ShadowColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1]





/**
 *  下划线颜色
 */
#define SY_UnderLineColorName @"#c8c8c8"//#ebebeb
#define SY_UnderLineColor colorWithHex(SY_UnderLineColorName)

/**
 *  Button未选中颜色
 */

#define SY_CommonButtonUnSelectColor [UIColor colorWithRed:255/255. green:49/255. blue:49/255. alpha:.5]
#define SY_CommonButtonSelectedColor [UIColor colorWithRed:255/255. green:49/255. blue:49/255. alpha:1.]

/**
 *  tableView的背景颜色
 */

#define SY_CommonTableViewBackgroundColor colorWithHex(@"#f0f0f0")

/**
 *  tableView上的分割线
 */
#define SY_TbaleViewCellSeparatorColor colorWithHex(@"#c8c8c8")


//placeholdColor
#define SY_PlaceholdColor colorWithHex(@"#dbdbdb")




#endif /* SYColorSet_h */
