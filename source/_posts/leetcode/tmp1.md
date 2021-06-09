id: 202006231110
title: 第一期
date: 2021-06-09 19:12:08
tags: "刷题"
categories: leetcode
---------
1. 如何记录?
```text
// 63题
func uniquePathsWithObstacles(obstacleGrid [][]int) int {
	var length = len(obstacleGrid)
	var leng = len(obstacleGrid[0])
	if length == 0 || leng == 0 {
		return 0
	}
	if obstacleGrid[0][0] == 1 {
		return 0
	}
	var tmp = make([][]int, length)
	for i := 0; i < length; i++ {
		for y := 0; y < leng; y++ {
			if i == 0 {
				if obstacleGrid[i][y] == 1 {
					tmp[i] = append(tmp[i], 0)
					continue
				}
				if y > 0 {
					if tmp[i][y-1] == 0 {
						tmp[i] = append(tmp[i], 0)
						continue
					}
				}
				tmp[i] = append(tmp[i], 1)
				continue
			}
			if y == 0 {
				if obstacleGrid[i][y] == 1 {
					tmp[i] = append(tmp[i], 0)
					continue
				}
				if i > 0 {
					if tmp[i-1][y] == 0 {
						tmp[i] = append(tmp[i], 0)
						continue
					}
				}
				tmp[i] = append(tmp[i], 1)
				continue
			}
			if obstacleGrid[i][y] == 1 {
				tmp[i] = append(tmp[i], 0)
				continue
			}
			tmp[i] = append(tmp[i], tmp[i][y-1]+tmp[i-1][y])
		}
	}
	return tmp[len(tmp)-1][len(tmp[0])-1]
}

//64题 最小路径
func minPathSum(grid [][]int) int {
	current := grid[0][0]
	var length = len(grid)
	var leng = len(grid[0])
	var tmp = make([][]int, length)
	// 初始化
	tmp[0] = append(tmp[0], grid[0][0])
	for y := 1; y < leng; y++ {
		tmp[0] = append(tmp[0], tmp[0][y-1]+grid[0][y])
		current = tmp[0][y]
	}
	for i := 1; i < length; i++ {
		for y := 0; y < leng; y++ {
			if y == 0 {
				tmp[i] = append(tmp[i], tmp[i-1][y]+grid[i][y])
				current = tmp[i][y]
				continue
			}
			if tmp[i-1][y] > tmp[i][y-1] {
				tmp[i] = append(tmp[i], tmp[i][y-1]+grid[i][y])
			} else {
				tmp[i] = append(tmp[i], tmp[i-1][y]+grid[i][y])
			}
			current = tmp[i][y]
		}
	}
	return current
}
```