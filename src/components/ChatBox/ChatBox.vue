<template>
    <div class="chat-box__container">
        <Heading tag="h2" headingClass="chat-box__title text--primary font--bold">Chats</Heading>
        <p v-if="chats.length === 0" class="chat-box__no-chats">No hay chats disponibles</p>
        <div v-else class="chat-box__chats">
            <div class="chat-box__chat" v-for="chat in chats" :key="chat.id" :style="{order: chat.id}">
                <messagesHandler :chatId="chat.id" :messages="chat.messages" @message-sent="fetchChats" />
                <Button class="chat-box__delete" @click.once="deleteChat(chat.id)">Eliminar Chat</Button>
            </div>
        </div>
        <form class="chat-box__new-chat" @submit.prevent="createChat">
            <Button type="submit">Crear un nuevo chat</Button>
        </form>
    </div>
</template>

<script>
import Heading from '../Heading/Heading.vue';
import Button from '../Button/Button.vue';
import messagesHandler from '../messagesHandler/messagesHandler.vue';

export default {
    name: 'ChatBox',
    components: {
        Heading,
        Button,
		messagesHandler
    },
    data() {
        return {
            chats: [],
        };
    },
    mounted() {
        this.fetchChats();
    },
    methods: {
        async fetchChats() {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch("http://127.0.0.1:8080/accounts/chats", {
                    method: "GET",
                    headers: {
                        "Authorization": `Bearer ${token}`
                    }
                });

                if (response.ok) {
                    const data = await response.json();
                    const chatsDetails = await Promise.all(data.map(async chat => {
                        const chatResponse = await fetch(`http://127.0.0.1:8080/chats/${chat.id}`, {
                            method: "GET",
                            headers: {
                                "Authorization": `Bearer ${token}`
                            }
                        });
                        if (chatResponse.ok) {
                            const chatData =  await chatResponse.json();
                            chat.messages = chatData.messages;
                            return chat;
                        }
                    }));
                    this.chats = chatsDetails;
                }
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        },
        async createChat() {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch("http://127.0.0.1:8080/chats", {
                    method: "POST",
                    headers: {
                        "Authorization": `Bearer ${token}`,
                        "Content-Type": "application/json"
                    }
                });

                if (response.ok) {
                    this.fetchChats();
                } else {
                    console.error("Error al crear el chat");
                }
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        },
        async deleteChat(chatId) {
            const token = sessionStorage.getItem("token");

            try {
                const response = await fetch(`http://127.0.0.1:8080/chats/${chatId}`, {
                    method: "DELETE",
                    headers: {
                        "Authorization": `Bearer ${token}`
                    }
                });

                if (response.ok) {
                    this.fetchChats();
                } else {
                    console.error("Error al eliminar el chat");
                }
            } catch (error) {
                console.error(`Error: ${error.message}`);
            }
        }
    }
};
</script>

<style lang="scss" scoped>
@use './ChatBox.scss';
</style>