# backup_script.cmake
# 用于直接调用备份命令（支持 cmake -P 执行）

# 设置路径
set(Project_Dir "/path/to/your/project")  # 修改为你的项目路径
set(SevenZipExe "7z")                     # 或写成 "C:/Program Files/7-Zip/7z.exe"

# 时间戳
string(TIMESTAMP TimeStamp "%Y%m%d_%H%M%S")
set(Backup_File "Backup_${TimeStamp}.7z")

message(STATUS "📁 备份目录: ${Project_Dir}")
message(STATUS "📦 输出文件: ${Backup_File}")

# 拉取 Git LFS（可选）
execute_process(
    COMMAND git lfs fetch --all
    WORKING_DIRECTORY "${Project_Dir}"
    RESULT_VARIABLE lfs_result
)

if(NOT lfs_result EQUAL 0)
    message(WARNING "⚠️ git lfs fetch 执行失败，可能未安装 Git LFS 或路径不正确")
endif()

# 执行压缩命令
execute_process(
    COMMAND ${SevenZipExe} a -mx=9 -r "${Backup_File}" "${Project_Dir}"
    RESULT_VARIABLE zip_result
)

if(zip_result EQUAL 0)
    message(STATUS "✅ 备份成功: ${Backup_File}")
else()
    message(FATAL_ERROR "❌ 压缩失败")
endif()
