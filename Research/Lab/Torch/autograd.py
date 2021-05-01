import torch


device =  'cuda' if torch.cuda.is_available() else 'cpu'
# we are creating a tensor with auto_grad set to True

x =  torch.randn(3,requires_grad=True,device=device)

# y  =  x + 2

# print( y )


# z =  y * y * 2
#
# # z  =  z.mean()
#
# v  =  torch.tensor([0.1,1,0.2],dtype=torch.float32)
#
# z.backward(v)
#
#
# print(x.grad)


# Preventing torch from tracking gradient

# method 1

# x.requires_grad_(False)

# Method 2
# z  =  x.detach() * 3
# print(x)


# with torch.no_grad():
#     y  =  x + 4
#     print(y)


weights  = torch.randn((4,3),requires_grad=True)
print(weights.size())