



def start():
    print(f"Launching SadTalker Web UI")
    from app_sadtalker import sadtalker_demo
    demo = sadtalker_demo()
    demo.queue()
    demo.launch()


if __name__ == "__main__":
    #prepare_environment()
    start()
