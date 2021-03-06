#include <vfs.h>

uint32_t
readfs(vfs_node_t *node, uint32_t offset, uint32_t size, uint8_t *buffer) 
{
	return node->read ? node->read(node, offset, size, buffer) : 0;
}

uint32_t
writefs(vfs_node_t *node, uint32_t offset, uint32_t size, uint8_t *buffer) 
{
	return node->write ? node->write(node, offset, size, buffer) : 0;
}

void
openfs(vfs_node_t *node/*, uint8_t read, uint8_t write*/) 
{
	if (node->open) 
		return node->open(node);
}

void
closefs(vfs_node_t *node) 
{
	if (node->close) 
		return node->close(node);
}

struct dirent*
readdir_fs(vfs_node_t *node, uint32_t index)
{
    return ((node->flags&0x7)==FS_DIRECTORY&&node->readdir)?node->readdir(node,index):0;
}

vfs_node_t*
finddir_fs(vfs_node_t *node, char *name)
{
    return ((node->flags&0x7)==FS_DIRECTORY&&node->finddir)?node->finddir(node,name):0;
}
