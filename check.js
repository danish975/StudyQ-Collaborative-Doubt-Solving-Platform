const { PrismaClient } = require('@prisma/client');
const prisma = new PrismaClient();
async function main() {
  const qs = await prisma.question.findMany({
    include: {
        author: true,
        tags: true,
        _count: { select: { answers: true, votes: true, comments: true } },
    }
  });
  console.log('Questions count:', qs.length);
  console.log(JSON.stringify(qs, null, 2));
}
main().catch(console.error).finally(()=>prisma.$disconnect());
