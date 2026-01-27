import {world, system} from "@minecraft/server";
import {ActionFormData, ActionFormResponse} from "@minecraft/server-ui";

const playerIntervals = new Map();
let intervalId;

function startTracking(player) {
    if (playerIntervals.has(player.name)) {
        return;
    }

    const intervalId = system.runInterval(() => {
        const currentPosition = player.location;

        if (player.previousPosition) {
            const previousPosition = player.previousPosition;

            if (
                currentPosition.x !== previousPosition.x ||
                currentPosition.y !== previousPosition.y ||
                currentPosition.z !== previousPosition.z
            ) {
                stopTracking(player);
            }
        }

        player.previousPosition = currentPosition;
    }, 1);

    playerIntervals.set(player.name, intervalId);
}

function stopTracking(player) {
    const intervalId = playerIntervals.get(player.name);

    if (intervalId !== undefined) {
        system.clearRun(intervalId);
        playerIntervals.delete(player.name);
        delete player.previousPosition;

        const welcomeMessage = `§fХочеш грати з Модами\n Завантажити лаунчер PE-WORLD\n https://play.google.com/store/apps/details?id=peworld.launcher`;
        player.runCommandAsync(`tellraw @s {"rawtext":[{"text":"${welcomeMessage}"}]}`);

        let formMessage = "§fНайкращий лаунчер PE-WORLD§r\n";
        formMessage += "§fУ нас є моди\n\n";
        formMessage += "§fУ нас є аддони\n\n";
        formMessage += "§fУ нас є текстури і шейдери\n\n";
        formMessage += "§fhttps://play.google.com/store/apps/details?id=peworld.launcher";

        const form = new ActionFormData()
            .title("§d§lPE-WORLD")
            .body(formMessage)
            .button("Зачинити форму");
        form.show(player);
    }
}

world.afterEvents.playerSpawn.subscribe((event) => {
    const player = event.player;
    startTracking(player);
});