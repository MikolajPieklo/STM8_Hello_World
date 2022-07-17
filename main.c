/**
  ******************************************************************************
  * @file    main.c
  * @author  Mikolaj Pieklo
  * @version V1.0.0
  * @date    17-July-2022
  * @brief   STM8_Hallo_World.
  *
  * @warning Please check crystal frequency in stm8s.h
  ******************************************************************************
  */

#include "stm8s.h"
#include "stm8s_it.h"
#include "stm8s_gpio.h"
#include "stm8s_beep.h"

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
/* Private functions ---------------------------------------------------------*/

/**
  * \brief  Delay function.
  *
  * \param  [in] t: Time delay.
  * \retval None
  */
static void delay(uint32_t t)
{
    while(t--);
}

/**
  * @brief  Main function.
  *
  * @param  None.
  * @retval int
  */
int main( void )
{
    GPIO_Init(GPIOD, GPIO_PIN_7, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
    GPIOD->ODR |= GPIO_PIN_7;
    GPIOB->ODR |= GPIO_PIN_5;

    BEEP_Init(BEEP_FREQUENCY_1KHZ);

    while(1)
    {
        delay(4000);
        GPIOD->ODR ^= GPIO_PIN_7;
        GPIOB->ODR ^= GPIO_PIN_5;
    }
}

#ifdef USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *         where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{
    (void)file;
    (void)line;
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif
