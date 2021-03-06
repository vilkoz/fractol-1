# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: vpopovyc <vpopovyc@student.42.fr>          +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2017/06/28 19:25:38 by vpopovyc          #+#    #+#              #
#    Updated: 2017/07/11 18:31:07 by vpopovyc         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

EXEC = fractol

# Compile rigth version of mlx correspoding to macos version
MACSYSTEMVERSION := $(shell sw_vers -productVersion | cut -d '.' -f 1,2)
ifeq ($(MACSYSTEMVERSION), 10.12)
	MLX_DIRECTORY := mlx_10.12/
	CCMACSYSTEMVERSION = -D__OSXSIERRA__ 
else
	MLX_DIRECTORY := mlx_10.11/
	CCMACSYSTEMVERSION = -D__OSXELCAPTAIN__
endif
MLX := $(addprefix $(MLX_DIRECTORY), libmlx.a)

HEADER = headers/cl_data.h headers/control.h headers/fractol.h 
SRC := view/main.c model/cl_draw.c model/const_computing.c control/control.c model/model.c
OBJ := $(SRC:.c=.o)
CC = clang
OBJFLAGS := -g -Wall -Wextra -Werror
EXECFLAGS := -Wall -Wextra -Werror -framework AppKit -framework OpenGL -framework OpenCL

.phony: all clean fclean re mlxclean
 
all: $(MLX) $(OBJ)
	$(CC) $(EXECFLAGS) $(CCMACSYSTEMVERSION) $(OBJ) $(MLX) -o $(EXEC) 


%.o: %.c ${HEADER}
	$(CC) $(OBJFLAGS) -o $@ -c $< 

clean: 
	/bin/rm -f $(OBJ) 

fclean: 
	/bin/rm -f $(OBJ) 
	/bin/rm -f $(EXEC) 

re: fclean mlxclean all 

$(MLX): 
	make -C $(MLX_DIRECTORY)

mlxclean:
	make -C $(MLX_DIRECTORY) clean
