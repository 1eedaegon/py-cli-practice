from asciimatics.effects import Print
from asciimatics.renderers import FigletText, Rainbow
from asciimatics.scene import Scene
from asciimatics.screen import Screen


def demo(screen: Screen):
    s = "아주 이쁜 테스트 씬"
    text = Rainbow(screen, FigletText(s, font="basic"))
    prn = Print(screen, text, (screen.height - text.max_height) // 2)
    screen.play([Scene([prn], -1, name="Main")])


# Screen.wrapper(main)

if __name__ == "__main__":
    print("메인")
    Screen.wrapper(demo)
