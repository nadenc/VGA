/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;



int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    unisims_ver_m_00000000001946988858_2297623829_init();
    unisims_ver_m_00000000004091665089_1758131789_init();
    unisims_ver_m_00000000003084551676_3289673958_init();
    unisims_ver_m_00000000003266096158_2593380106_init();
    work_m_00000000004143773638_2595139949_init();
    work_m_00000000001654314587_1069848932_init();
    work_m_00000000003533867292_0986243188_init();
    work_m_00000000002201244241_3567513237_init();
    work_m_00000000002340016839_1764654839_init();
    work_m_00000000004134447467_2073120511_init();


    xsi_register_tops("work_m_00000000002340016839_1764654839");
    xsi_register_tops("work_m_00000000004134447467_2073120511");


    return xsi_run_simulation(argc, argv);

}
