//-----State encoding----


/*[1]  default binary endcoding

    RESET = 0; WAITE = 1; LOAD = 2,..
*/
    typedef enum logic [1 : 0] {RESET, WAITE, LOAD, READY} state_t;
	
/*
    [2] explicit binary encoding----
*/
    typedef enum logic [1 : 0] {RESET = 0,
	                            WAITE = 1,
								LOAD  = 2,
								READY = 3	                           
	                           } state_binary_t;
							   